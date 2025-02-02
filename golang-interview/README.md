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

<a id="question4"></a>
## <h2 dir='rtl'>💡4- select در Go چگونه موارد پیش‌فرض (default cases) را مدیریت می‌کند؟</h2> 
عبارت `select` در Go می‌تواند شامل یک **مورد پیش‌فرض (default case)** باشد که در صورتی اجرا می‌شود که هیچ‌یک از موارد دیگر آماده نباشند. این قابلیت باعث می‌شود کد شما **غیربلاک‌کننده (non-blocking)** باشد، حتی اگر هیچ عملیات چنلی برای اجرا آماده نباشد.

🔧 **مثال**:

```Go
select {
case val := <-ch:
	fmt.Println(val)
default:
	fmt.Println("No data")
}
```

اگر چنل `ch` خالی باشد، پیام **"No data"** چاپ می‌شود.

🚀 **کاربردها**:
- مناسب برای **مدیریت تایم‌اوت‌ها**
- زمانی که نیاز به پیشرفت سریع و جلوگیری از توقف برنامه دارید

--- 

## <h2 dir='rtl'>💡5- defer، panic و recover در Go چگونه با یکدیگر استفاده می‌شوند؟</h2> 
در Go، سه ویژگی `defer`، `panic` و `recover` برای مدیریت خطاها به‌صورت مؤثر و جلوگیری از خرابی کامل برنامه استفاده می‌شوند:

✅ **panic**: برای اعلام خطاهای بحرانی که باعث متوقف شدن اجرای برنامه می‌شود.

✅ **defer**: برای تضمین اجرای یک قطعه کد، حتی در صورت وقوع خطا (مثل آزادسازی منابع یا بستن فایل‌ها).

✅ **recover**: داخل یک تابع `defer` استفاده می‌شود تا **panic** را بازیابی کرده و اجازه دهد برنامه به اجرای خود ادامه دهد.

🔧 **مثال**:

```Go 
package main

import "fmt"

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic:", r)
		}
	}()

	fmt.Println("Start of the program")
	panic("Something went wrong!")
	fmt.Println("This line will not be executed")
}
```

🚀 **نحوه کار**: 
- هنگام وقوع `panic`، اجرای برنامه متوقف شده و پشته (stack) بازگردانی می‌شود.
- توابع تعریف‌شده با `defer` اجرا می‌شوند.
- `recover`، اگر در یک تابع `defer` وجود داشته باشد، **panic** را بازیابی کرده و امکان ادامه اجرای برنامه را فراهم می‌کند.

--- 
