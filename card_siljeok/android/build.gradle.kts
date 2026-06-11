allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        if (hasProperty("android")) {
            try {
                val androidExt = extensions.getByName("android")
                val namespaceProp = androidExt.javaClass.getMethod("getNamespace").invoke(androidExt)
                if (namespaceProp == null) {
                    val groupStr = project.group.toString()
                    val validNamespace = if (groupStr.isNotEmpty()) groupStr else "com.plugin.${project.name.replace("-", "_")}"
                    androidExt.javaClass.getMethod("setNamespace", String::class.java).invoke(androidExt, validNamespace)
                }
            } catch (e: Exception) {}
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
