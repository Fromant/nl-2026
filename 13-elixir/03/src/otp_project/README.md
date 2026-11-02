# Настоящее OTP-приложение (слайд 11)

Этот небольшой Mix-проект создан вручную по структуре `mix new my_app --sup`,
чтобы можно было продемонстрировать настоящий callback `Application.start/2`.

## Запуск

```bash
cd otp_project
mix run -e 'IO.inspect(NL2026OTPDemo.Counter.increment(), label: "Counter")'
mix run -e 'IO.inspect(NL2026OTPDemo.Counter.get(), label: "Counter")'
mix test
```

Каждый `mix run` — новый запуск приложения, поэтому счётчик в нём начинается с нуля.
Для последовательного вызова в одном запуске:

```bash
mix run -e 'NL2026OTPDemo.Counter.increment(); IO.inspect(NL2026OTPDemo.Counter.get())'
```

Дочерние компоненты: `NL2026OTPDemo.Counter` (GenServer) и
`Task.Supervisor`, под управлением `NL2026OTPDemo.Supervisor`.

Зависимостей из Hex нет.
