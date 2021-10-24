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
          - name: kubectl
            image: vfarcic/kubectl
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
    stage('Build the image') {
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
          sh "curl https://staging-app.demo.devops-caffe.com/ | grep 'The meaning of life'"
          // To test it via the internal URL (Need to allow the host in the app)
          // curl sample-rails-app.staging.svc.cluster.local:8010
        }
      }
    }
  }
}