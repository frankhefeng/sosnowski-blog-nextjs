pipeline {
	agent {
        docker { 
            image 'node:lts-bullseye-slim' 
            args '-p 3000:3000 --privileged'
        }
    }
	
    stages {
        stage('build') {
            steps {
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