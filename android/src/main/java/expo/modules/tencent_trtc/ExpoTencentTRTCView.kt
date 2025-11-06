package expo.modules.tencent_trtc

import android.content.Context
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import com.tencent.rtmp.ui.TXCloudVideoView
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

class ExpoTencentTRTCView(context: Context, appContext: AppContext) :
    ExpoView(context, appContext) {

    internal val contentView = TXCloudVideoView(context).apply {
        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
    }

    init {
        addView(contentView)
    }
}
