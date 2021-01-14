pipeline {
    agent any

    environment {

    }

    stages {
        stage('Prepare') {

            steps {
                echo 'clonning Repository'

                git url: 'https://github.com/ChulHo-Kim/spring-boot-maven-example-helloworld.git'
                branch: 'dev'
                credentialId: 'ChulHo-Kim'
            }

            post {
                success {
                    echo 'Successfully Cloned Repository'
                }

                always {
                    echo ''
                }

                cleanup {

                }
            }
        }
        stage('Maven Build') {

        }
        stage('Docker Build With Tomcat') {

        }
        stage('Kubernetes Deploy') {

        }
    }

    post {
        success {
            mail to:'kch@tangunsoft.com'
            subject: 'Build & Deploy Success'
            body: '''
                Jenkins Build & Deploy Success!
                
                JOB_NAME : ${JOB_NAME}
                BUILD_NUMBER : ${BUILD_NUMBER}
                BUILD_URL : ${BUILD_URL}
            '''
        }
        failure {
            mail to:'kch@tangunsoft.com'
            subject: 'Build & Deploy failed'
            body: '''
                Jenkins Build & Deploy failed..
                
                JOB_NAME : ${JOB_NAME}
                BUILD_NUMBER : ${BUILD_NUMBER}
                BUILD_URL : ${BUILD_URL}
            '''
        }
    }
}