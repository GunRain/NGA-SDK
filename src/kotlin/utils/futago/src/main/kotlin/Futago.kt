@file:Suppress("PackageDirectoryMismatch", "unused")

package work.niggergo.app.futago

import android.app.Application
import android.content.Context
import android.content.res.Configuration
import com.highcapable.kavaref.KavaRef.Companion.asResolver
import com.highcapable.kavaref.KavaRef.Companion.resolve
import com.highcapable.kavaref.resolver.processor.MemberProcessor
import kotlin.reflect.KClass

class FutagoAppsDelegate<T : Application>(
	private val clazzes: List<KClass<T>>,
	var resolver: MemberProcessor.Resolver = MemberProcessor.globalResolver
) {
	val instances by lazy {
		clazzes.map {
			it.resolve().processor(resolver).firstConstructor { emptyParameters() }.create()
		}
	}

	fun appsAttachBaseContext(base: Context) = instances.forEach {
		it.asResolver().processor(resolver).firstMethod {
			name = "attachBaseContext"
			parameters(Context::class)
			superclass()
		}.invoke(base)
	}

	fun appsCreate() = instances.forEach { it.onCreate() }
	fun appsTerminate() = instances.forEach { it.onTerminate() }
	fun appsLowMemory() = instances.forEach { it.onLowMemory() }
	fun appsTrimMemory(level: Int) = instances.forEach { it.onTrimMemory(level) }
	fun appsConfigurationChanged(newConfig: Configuration) =
		instances.forEach { it.onConfigurationChanged(newConfig) }
}

interface FutagoAppsLoader<T> where T : Application, T : FutagoAppsLoader<T> {
	val futagoDelegate: FutagoAppsDelegate<out Application>

	fun appsAttachBaseContext() = futagoDelegate.appsAttachBaseContext(this as Context)
	fun appsCreate() = futagoDelegate.appsCreate()
	fun appsTerminate() = futagoDelegate.appsTerminate()
	fun appsLowMemory() = futagoDelegate.appsLowMemory()
	fun appsTrimMemory(level: Int) = futagoDelegate.appsTrimMemory(level)
	fun appsConfigurationChanged(newConfig: Configuration) =
		futagoDelegate.appsConfigurationChanged(newConfig)
}