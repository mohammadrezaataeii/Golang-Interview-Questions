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

<a id="question5"></a>
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
<a id="question6"></a>

## 💡6- پکیج math/big در Go چیست و چه زمانی از آن استفاده می‌کنیم؟

پکیج `math/big` در Go ابزارهایی برای **محاسبات با دقت دلخواه (arbitrary-precision arithmetic)** ارائه می‌دهد. این پکیج شامل انواعی مثل `big.Int`، `big.Float` و `big.Rat` است و برای عملیات عددی که از محدودیت‌های دقت انواع داده‌های داخلی فراتر می‌روند، استفاده می‌شود.

🚀 **کاربردها**:

- **رمزنگاری (Cryptography)**
- **محاسبات علمی**
- **برنامه‌های مالی که نیاز به دقت بالا دارند**

🔧 **مثال**:
```Go
package main

import (
	"fmt"
	"math/big"
)

func main() {
	a := big.NewInt(12345)
	b := big.NewInt(67890)

	// جمع دو عدد بزرگ
	result := new(big.Int).Add(a, b)
	fmt.Println("Result of addition:", result)

	// ضرب دو عدد بزرگ
	result.Mul(a, b)
	fmt.Println("Result of multiplication:", result)
}
```

🔧 **ویژگی‌ها**:

- ایجاد مقادیر با دقت دلخواه: `big.NewInt(12345)`
- انجام عملیات با استفاده از متدهایی مثل `Add`، `Mul`، و `Div`

---
<a id="question7"></a>
## <h2 dir='rtl'>💡7- Go چگونه فیلدهای غیراکسپورت‌شده (Unexported Fields) در Structها را هنگام JSON Marshaling مدیریت می‌کند؟ </h2> 
در Go، فیلدهای غیراکسپورت‌شده Struct (فیلدهایی که با حروف کوچک شروع می‌شوند) در فرآیند **JSON Marshaling** نادیده گرفته می‌شوند. علت این رفتار این است که این فیلدها خارج از پکیج خود غیرقابل دسترسی هستند.

✅ **برای اینکه یک فیلد در JSON شامل شود، باید اکسپورت‌شده باشد (حرف اول آن بزرگ نوشته شود).**
🔧 **مثال**:

```Go
package main

import (
	"encoding/json"
	"fmt"
)

type Person struct {
	Name string // اکسپورت‌شده
	age  int    // غیراکسپورت‌شده
}

func main() {
	p := Person{Name: "John", age: 30}
	jsonData, _ := json.Marshal(p)
	fmt.Println(string(jsonData)) // خروجی: {"Name":"John"}
}
```

--- 
<a id="question8"></a>
## 8-💡نحوه مدیریت concurrency در Maps در Go چگونه است و چه مشکلاتی ممکن است پیش بیاید؟

در Go، **Maps داخلی (built-in)** به‌صورت پیش‌فرض **thread-safe** نیستند، به این معنا که دسترسی همزمان به آن‌ها ممکن است باعث **race conditions** یا **panic در زمان اجرا** شود.

### ✅ **راهکارهای مدیریت همزمانی**:

1. **استفاده از sync.Mutex**:  
    با قفل کردن بخش‌های حساس کد، می‌توان دسترسی ایمن به map را تضمین کرد.

``` Go
var m = make(map[string]int)
var mu sync.Mutex

func safeWrite(key string, value int) {
    mu.Lock()
    m[key] = value
    mu.Unlock()
}

func safeRead(key string) int {
    mu.Lock()
    defer mu.Unlock()
    return m[key]
}
```

2- **استفاده از sync.Map**:
برای سناریوهایی که نیاز به دسترسی همزمان زیاد باشد، `sync.Map` طراحی شده و از مدیریت داخلی برای ایمنی در برابر همزمانی استفاده می‌کند.

```Go
var sm sync.Map

sm.Store("key", 42)            // نوشتن مقدار
value, ok := sm.Load("key")    // خواندن مقدار
```

### ⚠️ **مشکلات بالقوه**:

- **عدم استفاده از قفل**: ممکن است باعث رفتار غیرقابل پیش‌بینی و خرابی برنامه شود.
- **بلاک شدن قفل‌ها**: قفل‌های نادرست یا طولانی می‌توانند منجر به کاهش عملکرد شوند.
- **استفاده نادرست از sync.Map**: اگر نیاز به دسترسی مکرر و تغییرات زیاد باشد، ممکن است عملکرد کاهش یابد.
---
<a id="question9"></a>
## 9-💡تفاوت `runtime.Gosched` و `runtime.Goexit`؟

1. `runtime.Gosched()`

    - پردازش `goroutine` فعلی را متوقف کرده و اجازه می‌دهد سایر `goroutine` ها اجرا شوند.
    - این تابع `goroutine` را متوقف نمی‌کند، بلکه فقط پردازنده را به سایر `goroutineها` واگذار می‌کند.
    - برای **مدیریت همکاری در اجرای چندوظیفه‌ای (cooperative multitasking)** مفید است.

 2. `runtime.Goexit()`

- اجرای goroutine فعلی را متوقف می‌کند و آن را **برای همیشه** خاتمه می‌دهد.
- قبل از خروج، تمام توابع `defer` اجرا می‌شوند.
- برای **خروج ایمن از یک goroutine** بعد از انجام کارهای ضروری استفاده می‌شود.

🔧 مثال:

```Go
package main

import (
	"fmt"
	"runtime"
	"time"
)

func main() {
	go func() {
		for i := 0; i < 5; i++ {
			fmt.Println("Goroutine running", i)
			runtime.Gosched() // واگذاری پردازنده به سایر goroutineها
		}
	}()

	go func() {
		defer fmt.Println("Deferred call before exiting")
		fmt.Println("Goroutine about to exit")
		runtime.Goexit() // خاتمه goroutine
		fmt.Println("This will never be printed")
	}()

	time.Sleep(time.Second) // منتظر اجرای goroutineها
}
```

### خروجی:
```Go
Goroutine running 0
Goroutine running 1
Goroutine running 2
Goroutine running 3
Goroutine running 4
Goroutine about to exit
Deferred call before exiting

```

در این مثال:

- <span dir='rtl'>`runtime.Gosched()` اجازه می‌دهد سایر goroutineها اجرا شوند.</span>
- <span dir='rtl'>`runtime.Goexit()` بلافاصله goroutine را متوقف می‌کند اما قبل از خروج، `defer` اجرا می‌شود.</span>
#### چه زمانی از هرکدام استفاده کنیم؟

✔ <span dir='rtl'>`runtime.Gosched()`  را برای واگذاری پردازنده به سایر goroutineها استفاده کنید.  </span>
✔ <span dir='rtl'>`runtime.Goexit()` را برای خاتمه یک goroutine پس از انجام کارهای ضروری استفاده کنید.</span>

---
