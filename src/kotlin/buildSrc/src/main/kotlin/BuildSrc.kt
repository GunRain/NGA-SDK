import com.palantir.gradle.gitversion.VersionDetails
import groovy.lang.Closure
import org.gradle.api.Project
import org.gradle.api.publish.maven.MavenPublication
import org.gradle.kotlin.dsl.*

fun Project.configurePublishConfig(
	modName: String = "", desc: String = "", group: String = "work.niggergo.app",
): MavenPublication.() -> Unit = {
	from(components["release"])
	groupId = group
	val versionDetails: Closure<VersionDetails> by extra
	version = versionDetails().lastTag ?: "0.0"

	pom {
		name.set("NGA SDK${if (modName.isNotEmpty()) " $modName" else ""}")
		description.set(desc)
		url.set("https://app.niggergo.work/nga/")

		licenses {
			license {
				name.set("F2DLPRL")
				url.set("https://license.fileto.download/LICENSE.txt")
				distribution.set("repo")
			}
		}

		developers {
			developer {
				id = "shirorren"
				name = "ShIroRRen"
				email = "shiro@oom-wg.dev"
				url = "https://shiror.ren"
			}
		}

		organization {
			name.set("OOM WG")
			url.set("https://oom-wg.dev")
		}

		scm {
			connection.set("scm:git:https://github.com/ShIroRRen/NGA-SDK.git")
			developerConnection.set("scm:git:https://github.com/ShIroRRen/NGA-SDK.git")
			url.set("https://github.com/ShIroRRen/NGA-SDK.git")
		}
	}

	when (name) {
		"androidRelease" -> "releaseRuntimeClasspath"
		else             -> listOf(
			"${name}RuntimeClasspath", "${name}CompileKlibraries"
		).firstOrNull { project.configurations.findByName(it) != null }
	}?.let {
		versionMapping { allVariants { fromResolutionOf(it) } }
	}
}