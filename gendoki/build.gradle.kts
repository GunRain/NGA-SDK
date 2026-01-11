import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
	id("com.android.library")
	kotlin("android")
	`maven-publish`
	id("com.palantir.git-version")
}

kotlin.compilerOptions.jvmTarget = JvmTarget.JVM_1_8

android {
	namespace = "dev.oom_wg.purejoy.ccc.gendoki"
	compileSdk = gropify.config.compileSdk
	buildToolsVersion = gropify.config.buildToolsVersion

	defaultConfig {
		minSdk = gropify.config.minSdk
		consumerProguardFiles("consumer-rules.pro")
	}
	buildTypes {
		release {
			isMinifyEnabled = false
			proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
		}
	}
	compileOptions {
		sourceCompatibility = JavaVersion.VERSION_1_8
		targetCompatibility = JavaVersion.VERSION_1_8
	}
	buildFeatures {
		buildConfig = true
	}

	publishing {
		singleVariant("release") {
			withSourcesJar()
			// withJavadocJar()
		}
	}
}

afterEvaluate {
	publishing {
		publications {
			create<MavenPublication>("release", configurePublishConfig("gendoki", "GenDoki"))
		}
		repositories { mavenLocal() }
	}
}