//git的凭证
def git_auth = "3c624c30-b117-47c8-9e3e-c9551498e3a5"
//git地址
def git_url = "http://gitcebon.cebon-company.online:8080/fanyao/webtest.git"
//项目名称
def project_name = "webtest"
//构建版本的名称
def tag = "latest"
//程序的端口
// def port = 10086

//Harbor私服地址
def harbor_url = "192.168.99.78:85"
//Harbor的项目名称
def harbor_project_name = "webtest"
//Harbor的凭证
def harbor_auth = "734a87d9-5119-4c4f-bcb3-27c9a25b2ab1"

node {
    stage('拉取代码') {
        checkout([$class: 'GitSCM', branches: [[name: '*/${branch}']],
        doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [],
        userRemoteConfigs: [[credentialsId: "${git_auth}", url:"${git_url}"]]])
    }

    stage('编译，构建镜像') {
        //定义镜像名称
        def imageName = "${project_name}:${tag}"
        //编译，构建本地镜像
        sh "mvn clean package -Dmaven.test.skip dockerfile:build"
        //给镜像打标签
        sh "docker tag ${imageName} ${harbor_url}/${harbor_project_name}/${imageName}"//登录Harbor，并上传镜像

        withCredentials([usernamePassword(credentialsId: "${harbor_auth}",
        passwordVariable: 'password', usernameVariable: 'username')]) {
            //登录
            sh "docker login -u ${username} -p ${password} ${harbor_url}"
            //上传镜像
            sh "docker push ${harbor_url}/${harbor_project_name}/${imageName}"
        }

        //删除本地镜像
        sh "docker rmi -f ${imageName}"
        sh "docker rmi -f ${harbor_url}/${harbor_project_name}/${imageName}"
    }

    stage('部署服务器执行脚本'){
        //=====以下为远程调用进行项目部署========
        sshPublisher(publishers:
            [
                sshPublisherDesc(configName: '192.168.99.224',
                transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand:
                "/opt/jenkins_shell/back_deploy.sh $harbor_url $harbor_project_name $project_name $tag $port",
                execTimeout: 120000, flatten: false, makeEmptyDirs: false,
                noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '',
                remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')],
                usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)
            ]
        )
    }
}
