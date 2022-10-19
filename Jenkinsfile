pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                }
            }
            steps {
                sh '''
                    cd blog
                    echo 'Installing Dependencies'
                    npm install
                    echo 'Building NextJS App'
                    npx next build
                    npx next export
                '''
            }
        }
        stage('Deployment-Dev') {
            when { branch 'feat/**' }
            stages {
                stage('Deploy Infra') {
                    agent {
                        docker {
                            image 'hashicorp/terraform:light'
                            args '-i --entrypoint='
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                cd infra/blog; 
                                terraform init -input=false
                                terraform plan
                                terraform apply  -auto-approve
                            '''
                        }
                    }
                }
                stage('Deploy Website') {
                    agent {
                        docker {
                            image 'amazon/aws-cli '
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                cd blog/out
                                aws s3 sync . s3://sosnowski-blog-nextjs-965161619314
                            '''
                        }
                    }
                }

            }
        }
    }
}