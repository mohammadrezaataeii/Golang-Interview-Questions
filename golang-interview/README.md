<a id="question1"></a>
## 💡1- چگونه پکیج sync/atomic در Go از شرایط رقابتی (Race Conditions) جلوگیری می‌کند؟

پکیج `sync/atomic` در Go ابزارهایی برای **همگام‌سازی بدون قفل و سطح پایین** ارائه می‌دهد که به کمک آن می‌توان متغیرهای اشتراکی را به‌صورت ایمن مدیریت کرد. 

✅ **عملیات اتمیک**: توابعی مثل `AddInt32`، `LoadInt64` و `CompareAndSwap` تضمین می‌کنند که به‌روزرسانی متغیرهای اشتراکی به‌صورت **اتمیک** و امن انجام شود.

🔧 **مثال**:

```Go
import "sync/atomic"

var counter int32

// Incrementing the counter safely
atomic.AddInt32(&counter, 1)
```

با استفاده از `atomic.AddInt32`، گوروتین‌های مختلف می‌توانند بدون ایجاد شرایط رقابتی(Race Conditions)، مقدار `counter` را افزایش دهند.

---
<a id="question2"></a>
## 💡2-چگونه Go با استفاده از پکیج time،تایم زون را مدیریت می‌کند؟

پکیج `time` در Go با استفاده از نوع `time.Location` پشتیبانی کاملی برای مدیریت مناطق زمانی ارائه می‌دهد. به‌صورت پیش‌فرض، مقادیر زمان در منطقه زمانی محلی (**Local Time Zone**) هستند، اما به‌راحتی می‌توان آن‌ها را به سایر مناطق زمانی تبدیل کرد.

🔧 **مثال**:

```Go 
import "time"

currentUTC := time.Now().In(time.UTC)
fmt.Println("زمان فعلی در UTC:", currentUTC)
```

همچنین می‌توانید با استفاده از `time.LoadLocation` مناطق زمانی سفارشی را بارگذاری کنید و تبدیل‌های دقیق زمان را برای مناطق مختلف انجام دهید:

```Go
loc, _ := time.LoadLocation("Asia/Tehran")
localTime := time.Now().In(loc)
fmt.Println("زمان فعلی در تهران:", localTime)
```

این ویژگی به شما امکان می‌دهد تا محاسبات زمانی را در برنامه‌های جهانی به‌راحتی انجام دهید. 🌍

---
<a id="question3"></a>
## 💡3- پکیج net/http در Go چیست و چگونه ساخت سرور HTTP را ساده می‌کند؟

پکیج `net/http` ابزارهایی برای ساخت سرور و کلاینت HTTP ارائه می‌دهد. این پکیج با استفاده از تابع `http.ListenAndServe`، فرآیند ایجاد سرور HTTP را بسیار ساده می‌کند. این تابع سرور را راه‌اندازی کرده و درخواست‌های ورودی را با استفاده از رابط‌های `http.Handler` یا توابعی مثل `http.HandleFunc` مدیریت می‌کند.

🔧 **مثال**:
```Go 
import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello, World!")
	})

	http.ListenAndServe(":8080", nil)
}
```

این کد یک سرور HTTP ساده را تنها با چند خط کدنویسی راه‌اندازی می‌کند که به درخواست‌های ورودی پاسخ "Hello, World!" می‌دهد.

---
