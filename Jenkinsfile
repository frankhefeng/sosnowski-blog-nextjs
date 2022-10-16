pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile.build'
            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
        }
    }
	
    stages {
        stage('build') {
            steps {
                echo 'Installing Dependencies'
                sh 'npm install'
				echo 'Building NextJS App'
				sh 'npx next build && npx next export'
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