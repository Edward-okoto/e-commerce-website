# e-commerce-website

Let's create a simple **test project** to illustrate the deployment workflow using Jenkins and Docker. I'll create a basic **Maven project** that includes an `index.html` file served via a lightweight **Spring Boot application**. We'll deploy it as a Docker container and push the Docker image to Docker Hub. Follow along with the steps to implement it.

---

## **Step 1: Set Up the Project**
### Create a simple Spring Boot project with Maven:
You can use the **Spring Initializr** tool to generate a test project. Alternatively, create the project manually.

#### **Basic Directory Structure**
```
/TestProject
 ├── src/main/java/com/example/demo
 │    └── DemoApplication.java
 ├── src/main/resources/static
 │    └── index.html
 ├── pom.xml
 ├── Dockerfile
```

---

### **Code Files**

#### **1. `DemoApplication.java`**
This is the main entry point for the Spring Boot app.
```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

#### **2. `index.html`**
This is a simple HTML file that will be served by the app.
```html
<!DOCTYPE html>
<html>
<head>
    <title>Test Project</title>
</head>
<body>
    <h1>Welcome to the Test Project!</h1>
</body>
</html>
```

#### **3. `pom.xml`**
This is the Maven configuration file.
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

#### **4. `Dockerfile`**
The Dockerfile builds a container image for the project.
```dockerfile
FROM openjdk:11-jre-slim
COPY target/demo-1.0-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

---

## **Step 2: Clone the Repository**
Commit this project to your **GitHub repository**. For example:
```
https://github.com/<your-username>/TestProject
```

---

## **Step 3: Configure Your Jenkins Pipeline**
Create a **Jenkinsfile** in the repository to automate the steps:
1. Clone the code.
2. Build the project.
3. Test it.
4. Build a Docker image.
5. Push the image to Docker Hub.

#### **Jenkinsfile**
```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'edwardokoto1/e-commerce-website'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning repository from GitHub...'
                git branch: 'main', url: 'https://github.com/Edward-okoto/e-commerce-website.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the Maven project...'
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                        echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
```

---

## **Step 4: Implement the Project**
1. **Set Up Docker Hub**:
   - Create a repository called `test-project` in Docker Hub.

2. **Set Up Jenkins Pipeline**:
   - Create a **Pipeline Job** in Jenkins.
   - Configure it to use the `Jenkinsfile` from your GitHub repository.

3. **Add Credentials**:
   - Add **Docker Hub credentials** in Jenkins under **Manage Jenkins > Manage Credentials**.
   - Use the ID `dockerhub-credentials` in the pipeline.

---

## **Step 5: Trigger the Pipeline**
- Click **Build Now** in Jenkins to trigger the pipeline.
- Monitor the build stages and ensure:
  1. Code is successfully cloned from GitHub.
  2. The Maven project is built and tested.
  3. Docker image is built and pushed to Docker Hub.

---

## **Step 6: Verify the Deployment**
1. **Check Docker Hub**:
   - Verify that the image `your-dockerhub-username/test-project:latest` exists.

2. **Run the Docker Container**:
   ```bash
   docker run -d -p 8080:8080 your-dockerhub-username/test-project:latest
   ```
3. **Access the Application**:
   - Open a browser and navigate to `http://localhost:8080` to see the `index.html` content.

---
