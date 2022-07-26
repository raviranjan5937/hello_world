	pipeline {
	 agent none
	 
	 stages
	  {
	   stage('checkout')
		{
		 agent {label 'test'}
		 steps {
		  git branch: 'master', url: 'https://github.com/raviranjan5937/hello_world.git'
				}
		}
		stage('Build war')
		 {
		  agent {label 'test'}
		  steps {
		   sh "mvn clean package"
				 }
		  }
		stage('Build Image')
		 {
		   agent {label 'test'}
		   steps{
		    script {
			     /* URL of Dockerhub and Unique ID given/generated while adding Credentials of Dockerhub in Jenkins */
		      docker.withRegistry('https://registry.hub.docker.com', 'dockerhub'){
			     /* Build Docker Image locally; For more info: https://jenkins.io/doc/book/pipeline/docker/ */
				 myImage = docker.build("raviranjan5937/hello_world:${env.BUILD_ID}")
				 /* Push the container to the Registry */
				 myImage.push()
				   }
				}
			}
		}
			
				 
		 stage ('Upload Artifactory')
		  {
		   agent {label 'test'}
		   steps {
		    script {
		            /*Define the Artifactory Server details */
		         def server = Artifactory.server 'jfrogartifactory'
		         def uploadSpec = """{
		             "files": [{
		             "pattern": "target/samplewar.war",
		             "target": "demo"
		             }]
		         }"""
		         /* Upload the war to Artifactory repo */
		         server.upload(uploadSpec)
		    }
		   }

		  }
		  stage('SonarQube Analysis') 
		   {
		    agent {label 'test'}
		    steps{
		     withSonarQubeEnv('mysonarqube') {
		      sh 'mvn sonar:sonar'
		     }
		    }
		  }
		stage ('Deployment k8s')
		  {
		    agent { label 'deploy' }
			steps {
			  sh "kubectl apply -f deploy.yml"
			}
		   }
	   }
	post
    {
	 success {
	    echo 'JENKINS PIPELINE IS SUCCESSFUL'
	}
	failure {
	    mail body: 'Pipeline Details', subject: 'The pipeline failed', to: 'raviranjan5937@gmail.com'
	}
	}
  
}
