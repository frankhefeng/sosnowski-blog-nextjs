pipeline {
    agent none
    environment {
        GIT_BRANCH_NAME = GIT_BRANCH.split('/').size() > 1 ? GIT_BRANCH.split('/')[1..-1].join('/') : GIT_BRANCH
        APP_ENV = "app-${GIT_BRANCH_NAME}"
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
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
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
                                aws s3 sync . s3://sosnowski-blog-nextjs-965161619314-$APP_ENV
                            '''
                        }
                    }
                }

            }
        }
    }
}