package dev.oom_wg.purejoy.ccc.moesa

import android.app.Application
import android.os.Process.killProcess
import android.os.Process.myPid
import android.system.Os.stat
import android.system.OsConstants.*
import android.system.StructStat
import dev.oom_wg.purejoy.ccc.gendoki.GenDokiInitializer
import kotlin.system.exitProcess

class MoeSaChecker : GenDokiInitializer() {
	override fun Application.onInit() = runCatching {
		val apkPath = applicationInfo.sourceDir
		val apkStat = stat(apkPath)
		fun kill(): Nothing = killProcess(myPid()).let { exitProcess(-1) }

		val pmProc = Runtime.getRuntime().exec(arrayOf("pm", "path", packageName))
		val pmApkPath =
			pmProc.inputStream.bufferedReader().useLines { it.firstOrNull()?.removePrefix("package:") }
		if (apkPath != pmApkPath) kill()

		val startOk = apkPath.startsWith("/data/app/")
		val endOk = apkPath.endsWith("/base.apk")
		val pkgOk = apkPath.contains("/$packageName")
		if (!startOk || !endOk || !pkgOk) kill()

		val uid = apkStat.st_uid
		val gid = apkStat.st_gid
		if (uid to gid != 1000 to 1000) kill()

		fun StructStat.modeBits(r: Int, w: Int, x: Int): Int {
			var value = 0
			if (st_mode and r != 0) value += 4
			if (st_mode and w != 0) value += 2
			if (st_mode and x != 0) value += 1
			return value
		}

		val user = apkStat.modeBits(S_IRUSR, S_IWUSR, S_IXUSR)
		val group = apkStat.modeBits(S_IRGRP, S_IWGRP, S_IXGRP)
		val other = apkStat.modeBits(S_IROTH, S_IWOTH, S_IXOTH)
		if (user !in 5..6) kill()
		if (group !in 4..5) kill()
		if (other !in 4..5) kill()
	}.onFailure { error("") }.let {}
}