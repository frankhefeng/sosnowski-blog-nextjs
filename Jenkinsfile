#!groovy

pipeline {
    environment {
            JENKINS_USER_NAME = "${sh(script:'id -un', returnStdout: true).trim()}"
            JENKINS_USER_ID = "${sh(script:'id -u', returnStdout: true).trim()}"
            JENKINS_GROUP_ID = "${sh(script:'id -g', returnStdout: true).trim()}"
    }
    agent {
        dockerfile {
            filename 'Dockerfile.build'
            additionalBuildArgs '''\
                --build-arg GID=$JENKINS_GROUP_ID \
                --build-arg UID=$JENKINS_USER_ID \
                --build-arg UNAME=$JENKINS_USER_NAME \
            '''
        }
    }
	
    stages {
        stage('build') {
            steps {
                echo 'Switch to node user'
                sh 'su - node'
                echo 'Installing Dependencies'
                sh 'npm install'
				echo 'Building NextJS App'
				sh 'next build && next export'
            }
        }
        stage('deploy development') {
            steps {
                echo 'Deploy Development'
            }
        }
        stage('deploy staging') {
            steps {
                echo 'Deploy Staging'
            }
        }
		stage('deploy production') {
			steps {
				echo 'Deploy Production'
			}
		}
    }
	// post {
	// 	failure {
	// 		mail to: 'frankhe.cn@gmail.com', subject: 'Pipeline failed', body: "${env.BUILD_URL}"
	// 	}
	// }
}