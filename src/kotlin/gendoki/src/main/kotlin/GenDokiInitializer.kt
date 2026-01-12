@file:Suppress("PackageDirectoryMismatch", "unused")

package dev.oom_wg.purejoy.ccc.gendoki

import android.app.Application
import android.content.ContentProvider
import android.content.ContentValues
import android.net.Uri

@Suppress("LocalVariableName")
abstract class GenDokiInitializer : ContentProvider() {
	protected abstract fun Application.onInit()

	final override fun onCreate() =
		runCatching { (context?.applicationContext as? Application)?.onInit() }.isSuccess

	override fun delete(`_`: Uri, `__`: String?, `--`: Array<out String?>?) = error("")
	override fun getType(`_`: Uri) = error("")
	override fun insert(`_`: Uri, `__`: ContentValues?) = error("")
	override fun query(
		`_`: Uri, `__`: Array<out String?>?, `--`: String?, `_-`: Array<out String?>?, `-_`: String?
	) = error("")

	override fun update(`_`: Uri, `__`: ContentValues?, `--`: String?, `_-`: Array<out String?>?) =
		error("")
}