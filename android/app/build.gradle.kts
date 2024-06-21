plugins{
    id("com.android.application")
    id("com.google.gms.google-services") 
}
dependencies{
   implementation(platform("com.google.firebase:firebase-bom:32.8.1")) 
   implementation("com.google.firebase:firebase-analytics")
}