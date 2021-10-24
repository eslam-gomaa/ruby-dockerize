

## Description

This is a demo Jenkins Pipeline for a containerized ruby on rails app, & **includes the following stags:**
  1. Development Build & run unit tests
  2. Build the prod docker image
  3. Push the image to docker hub
  4. Deploy the app to the staging ENV (staging namespace)
  5. Deploy the app to the prod ENV (prod namespace)


---

As required by the task, Here is the [Kubernetes yaml](https://github.com/eslam-gomaa/ruby-dockerize/tree/main/k8s-app)


---

## Environment description

* The work has been done on a `Test K8s cluster`  which also hosts Jenkins
* **3 namespaces has been used:**
  * build `->`  Used by Jenkins to build the app (it utilized k8s pods as agent)
    * Also used to deploy the app on both staging & prod namespaces
  * staging `->` imitation of the staging environment
  * prod `->` imitation of the production environment


---


Staging URL:    https://staging-app.demo.devops-caffe.com

Production URL: https://prod-app.demo.devops-caffe.com


Jenkins URL: https://jenkins.demo.devops-caffe.com/jenkins/
> admin
>
> password

Where the images are pushed: [Docker hub](https://hub.docker.com/repository/docker/eslamgomaa/dockerizing-ruby-drkiq)

---


<details>
    <summary>
        <b style="font-size:20px" >Pipeline screenshoots
</b>
    </summary>

    
  
</details>



---

Thank you

