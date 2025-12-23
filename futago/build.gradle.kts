import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
	id("com.android.library")
	kotlin("android")
	`maven-publish`
}

kotlin.compilerOptions.jvmTarget = JvmTarget.JVM_17

android {
	namespace = "dev.oom_wg.purejoy.ccc.futago"
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
		sourceCompatibility = JavaVersion.VERSION_17
		targetCompatibility = JavaVersion.VERSION_17
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
	implementation("com.highcapable.kavaref:kavaref-core:+")
}

afterEvaluate {
	publishing {
		publications {
			create<MavenPublication>("release", configurePublishConfig("futago", "Futago"))
		}
		repositories {
			mavenLocal()
		}
	}
}