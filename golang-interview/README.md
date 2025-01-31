## 💡چگونه پکیج sync/atomic در Go از شرایط رقابتی (Race Conditions) جلوگیری می‌کند؟

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