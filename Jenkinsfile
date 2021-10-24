pipeline {
  environment { 
    registry = "https://registry.hub.docker.com/eslamgomaa" 
    registryCredential = 'docker_hub_id' 
    dockerImage = '' 
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
          name: cd
          label:
            app: rails
        spec:
          serviceAccountName: staging-prod-create
          containers:
          - name: docker
            image: docker:18.03-git
            command: ["sleep"]
            args: ["100000"]
            tty: true
            volumeMounts:
            - name: docker-socket
              mountPath: /var/run/docker.sock
            workingDir: /workspace
          - name: docker-compose 
            image: tmaier/docker-compose
            command: ["sleep"]
            args: ["100000"]
            tty: true
            workingDir: /workspace
          - name: kubectl 
            image: vfarcic/kubectl
            command: ["sleep"]
            args: ["100000"]
            tty: true
            workingDir: /workspace
          - name: curl
            image: byrnedo/alpine-curl
            command: ["sleep"]
            args: ["100000"]
            tty: true
            workingDir: /workspace
          volumes:
          - name: docker-socket
            hostPath:
              path: /var/run/docker.sock
              type: Socket
        '''
    }
  }
  stages {
    stage('Cloning the Git Repo') { 
      steps { 
        git branch: 'main',
            credentialsId: 'f0a87b6b-822e-4502-8051-47a170675cc3',
            url: 'https://github.com/eslam-gomaa/ruby-dockerize.git'
        sh 'pwd'
        sh 'ls -lh'
      }
    }
    stage('Development build with Docker-compose') {
      steps {
        container('docker-compose') {
          sh 'ls -lh'
          // Create docker volumes
          sh  '''docker volume create --name drkiq-postgres
                 docker volume create --name drkiq-redis
              '''
          // Run docker-compose up
          sh  '''cp env-example .env
                 docker-compose up -d
              '''
          // Initialize DBs
          sh  '''docker-compose run drkiq rake db:reset
                 docker-compose run drkiq rake db:migrate
              '''
          // Run Docker-compose down
          sh 'docker-compose up -d'          
          // Install prerequisits
          sh  '''docker-compose run --user "$(id -u):$(id -g)" drkiq rails webpacker:install
                 docker-compose run --user "$(id -u):$(id -g)" drkiq rails assets:precompile
              '''
          // Create DBs
          sh  '''docker-compose run drkiq bundle exec rake db:create test
                 docker-compose run drkiq bundle exec rake db:create development || echo 'development DB exists'
              '''
          // Run Unit tests
          sh 'docker-compose run drkiq rails test'
          // Run Docker-compose down
          sh 'docker-compose down --volumes'
        }
      }
    }
    stage('Build the production image') {
      steps {
        container('docker') {
          sh 'ls -lh'
          sh  "docker build -t eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER} --cache-from=eslamgomaa/dockerizing-ruby-drkiq:latest -f Dockerfile.production ."
        }
      }
    }
    stage('Push the image to Docker hub') {
      steps {
        container('docker') {
          script { 
            docker.withRegistry( registry, registryCredential ) { 
              docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("${env.BUILD_NUMBER}")
              docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("latest")
            }
          }
        }
      }
    }
    stage('Deploy on Staging namespace') {
      steps {
        container('kubectl') {
          sh 'kubectl apply -f k8s-app/staging/ -n staging'
          // Waiting for the Pods to be initialized before running the tests
          sh 'chmod +x k8s-app/scripts/test-staging.sh'
          sh './k8s-app/scripts/test-staging.sh'
          // Run a simple test
          sh 'sleep 5'

        }
        container('curl') {
          sh "curl https://staging-app.demo.devops-caffe.com/ | grep 'The meaning of life'"
          // To test it via the internal URL (Need to allow the host in the app)
          // curl sample-rails-app.staging.svc.cluster.local:8010
        }
      }
    }
    stage('Deploy on Prod namespace') {
      steps {
        container('kubectl') {
          input("Deploy on Prod ?")
          sh 'kubectl apply -f k8s-app/prod/ -n prod'
          // Waiting for the Pods to be initialized before running the tests
          sh 'chmod +x k8s-app/scripts/test-staging.sh'
          sh './k8s-app/scripts/test-prod.sh'
          // Run a simple test
          sh 'sleep 5'
        }
        container('curl') {
          sh "curl https://prod-app.demo.devops-caffe.com/ | grep 'The meaning of life'"
          // To test it via the internal URL (Need to allow the host in the app)
          // curl sample-rails-app.staging.svc.cluster.local:8010
        }
      }
    }
  }
}