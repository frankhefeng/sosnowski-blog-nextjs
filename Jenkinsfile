pipeline {
    agent none
    environment {
        BRANCH_NAME = "${GIT_BRANCH.split("/")[1]}"
    }
    stages {
        stage('dev') {
            when { branch 'feat/**' }
            stages {
                stage('Infra') {
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
                                terraform workspace select $BRANCH_NAME || terraform workspace new $BRANCH_NAME
                                terraform plan
                                terraform apply -var="branch_name=$BRANCH_NAME" -auto-approve
                            '''
                        }
                    }
                }
                stage('Website') {
                    agent {
                        dockerfile {
                            filename 'Dockerfile.build'
                            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                                cd out
                                aws s3 sync . s3://sosnowski-blog-nextjs-965161619314-$BRANCH_NAME
                            '''
                        }
                    }
                }

            }
        }
    }
}