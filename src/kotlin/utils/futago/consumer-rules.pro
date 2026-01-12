-keepclassmembers class * extends android.app.Application {
	public <init>(...);
	protected void attachBaseContext(android.content.Context);
	public void onCreate();
	public void onTerminate();
	public void onConfigurationChanged(android.content.res.Configuration);
	public void onLowMemory();
	public void onTrimMemory(int);
}