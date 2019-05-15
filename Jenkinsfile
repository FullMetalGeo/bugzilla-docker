#!groovy

node {
    properties([
        disableConcurrentBuilds(),
        [
            $class: 'GithubProjectProperty',
            projectUrlStr: 'https://github.com/FullMetalGeo/bugzilla-docker'
        ],
        pipelineTriggers([
            githubPush(),
        ])
    ])

    stage ('Clear workspace'){
        deleteDir()
    }

    stage ('Checkout'){
      checkout scm
    }

    stage('Prepare Docker Environment') {
        dockerEnvironment()
    }

    stage('Build Docker Image'){
        dockerBuild {
            useCache = "false"
        }
    }

    stage("Push Docker Image to ECR"){
        dockerPush()
    }

    stage("Update Parameter Store"){
        setBaseTag()
    }

    stage('Deploy Docker to ECS') {
        cfnDeploy()
    }
}
