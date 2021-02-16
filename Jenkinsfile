pipeline {
    agent any

    environment {
        docker_registry_ip = '192.168.10.203'
        docker_registry_port = '5000'
        docker_registry_id = 'nis'
    }

    stages {
        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${JOB_NAME}:${BUILD_NUMBER} -f Dockerfile .'
            }
        }

        stage('Docker Image Push Nexus') {
            steps {
                sh 'cat /var/jenkins_home/password/docker_registry.txt | docker login ${docker_registry_ip}:${docker_registry_port} -u ${docker_registry_id} --password-stdin'
                sh 'docker tag ${JOB_NAME}:${BUILD_NUMBER} ${docker_registry_ip}:${docker_registry_port}/${JOB_NAME}:${BUILD_NUMBER}'
                sh 'docker push ${docker_registry_ip}:${docker_registry_port}/${JOB_NAME}:${BUILD_NUMBER}'
                sh 'docker rmi ${docker_registry_ip}:${docker_registry_port}/${JOB_NAME}:${BUILD_NUMBER}'
                sh 'docker rmi ${JOB_NAME}:${BUILD_NUMBER}'
                sh 'docker logout'
            }
        }

        stage('Kubernetes Deploy') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'k8s-master'
                    remote.host = '192.168.10.227'
                    remote.user = 'root'
                    remote.password = 'eksrnsthvmxm1!'
                    remote.allowAnyHosts = true
                    stage('Remote SSH') {
                        sshCommand remote: remote, command: "cat /home/isb/password/docker_registry.txt | docker login ${docker_registry_ip}:${docker_registry_port} -u ${docker_registry_id} --password-stdin"

                        sshCommand remote: remote, command: "mkdir -p /jenkins_deploy/${JOB_NAME}/"
                        sshPut remote: remote, from: 'k8s/*', into: "'/jenkins_deploy/${JOB_NAME}/'"


                        /**
                        sshCommand remote: remote, command: "kubectl apply -f https://raw.githubusercontent.com/ChulHo-Kim/spring-boot-maven-example-helloworld/master/k8s/ingress-nginx-baremetal-deploy.yaml"
                        sshCommand remote: remote, command: "kubectl apply -f https://raw.githubusercontent.com/ChulHo-Kim/spring-boot-maven-example-helloworld/master/k8s/deployment.yaml"
                        sshCommand remote: remote, command: "kubectl apply -f https://raw.githubusercontent.com/ChulHo-Kim/spring-boot-maven-example-helloworld/master/k8s/service.yaml"
                        sshCommand remote: remote, command: "kubectl apply -f https://raw.githubusercontent.com/ChulHo-Kim/spring-boot-maven-example-helloworld/master/k8s/ingress.yaml"
                        **/
                        sshCommand remote: remote, command: "docker logout"
                    }
                }
            }
        }

    }

    post {
        success {
            mail to: 'kch@tangunsoft.com', from: 'jenkins@tangunsoft.com',
                    subject: "Example Build: ${env.JOB_NAME} - Success",
                    body: "Job Success - \"${env.JOB_NAME}\" build: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}\n\nBlue Ocean:\n${env.RUN_DISPLAY_URL}"
        }
        failure {
            mail to: 'kch@tangunsoft.com', from: 'jenkins@tangunsoft.com',
                    subject: "Example Build: ${env.JOB_NAME} - Failed",
                    body: "Job Failed - \"${env.JOB_NAME}\" build: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}\n\nBlue Ocean:\n${env.RUN_DISPLAY_URL}"
        }
    }
}