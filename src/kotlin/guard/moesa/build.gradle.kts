import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
	id("com.android.library")
	kotlin("android")
	`maven-publish`
	id("com.palantir.git-version")
}

kotlin.compilerOptions.jvmTarget = JvmTarget.JVM_1_8

android {
	namespace = "work.niggergo.app.e_war.sandbox.moesa"
	compileSdk = 36
	buildToolsVersion = "36.1.0"

	defaultConfig {
		minSdk = 1
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

// noinspection GradleDynamicVersion
dependencies {
	implementation(project(":utils:gendoki"))
}

afterEvaluate {
	publishing {
		publications {
			create<MavenPublication>(
				"release", configurePublishConfig(
					"MoeSa", "EWar Sandbox MoeSa", "work.niggergo.app.e_war.sandbox"
				)
			)
		}
		repositories { mavenLocal() }
	}
}