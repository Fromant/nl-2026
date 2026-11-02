# Elixir — третья презентация: процессы, BEAM, OTP, отказоустойчивость

**Авторы:** Назарова Анастасия, Шилов Павел (СПбПУ, ВШПМиВФ). **Год:** 2026.

Все примеры созданы средствами стандартной библиотеки Elixir/Erlang/OTP. Пакеты Hex не требуются.
Для обычной демонстрации достаточно установленного Elixir (рекомендуется 1.14+).

## Содержание

| Слайд | Исходник | Что демонстрирует |
|---|---|---|
| 02 | `02_concurrency_parallelism.exs` | Конкурентные задачи и планировщики BEAM |
| 03 | `03_beam_vm.exs` | PID, процессы, память BEAM, сообщения |
| 04 | `04_spawn_pid.exs` | `spawn/1`, `self/0`, `send/2` |
| 05 | `05_mailbox_receive.exs` | Mailbox, `receive`, выбор по шаблону, timeout |
| 06 | `06_state_setter_getter.exs` | Хранение состояния через рекурсивный цикл |
| 07 | `07_links_monitors.exs` | Link и Monitor, сообщения `:EXIT` и `:DOWN` |
| 08 | `08_task_agent.exs` | `Task.async/await` и `Agent.get/update` |
| 09 | `09_genserver.exs` | Счётчик с `handle_call` / `handle_cast` |
| 10 | `10_supervisor.exs` | Перезапуск дочернего процесса (`:one_for_one`) |
| 11 | `11_otp_supervision_tree.exs` | Supervision tree (Agent + Task.Supervisor) |
| 12 | `12_let_it_crash.exs` | Let It Crash; состояние после рестарта |
| 13 | `13_memory_gc.exs` | GC, неизменяемые списки, O(1) для `[head | tail]` |
| 14 | `14_distributed_nodes.exs` | Узлы, `Node.connect` и сообщения между VM |
| 15 | `15_integrated_demo.exs` | Supervisor + Task.Supervisor + Agent |

`14_remote_receiver.exs` — вспомогательный код для работы с двумя узлами.
`otp_project/` — настоящий Mix-проект с OTP `Application` и тестами.
`test/smoke_test.exs` — проверки запуска всех локальных примеров.
`main.exs` — единый запуск всех обычных `.exs`.

## Быстрый запуск

Из папки `03/src/`:

```bash
elixir main.exs
```

Или запуск отдельного слайда:

```bash
elixir 06_state_setter_getter.exs
elixir 10_supervisor.exs
```

## Проверка

```bash
elixir test/smoke_test.exs
cd otp_project && mix test
```

## Запуск через Docker (необязательно)

Из `03/src/`:

```bash
docker build -t elixir-nl-03 .
docker run --rm elixir-nl-03
```

Для интерактивного запуска конкретной программы:

```bash
docker run --rm elixir-nl-03 elixir 07_links_monitors.exs
```

## Слайд 14: две независимые виртуальные машины

**Терминал 1** — запустите получатель:

```bash
iex --sname receiver --cookie nl2026 -r 14_remote_receiver.exs
```

В интерактивной консоли получите точное имя узла:

```elixir
Node.self()
```

**Терминал 2** — подставьте вместо `HOST` реальное имя хоста, показанное
`Node.self()` (например, `receiver@my-pc`):

```bash
elixir --sname sender --cookie nl2026 14_distributed_nodes.exs --remote receiver@HOST
```

Внимание: при отсутствии второго узла запуск `elixir 14_distributed_nodes.exs`
завершается успешно, но не выполняет сетевой обмен. Для межузловой связи
нужны работающая сеть и одинаковый Erlang cookie.

## Что важно при защите

1. Внутри `Process` состояние меняется через **новый рекурсивный вызов**, а не мутацию значения.
2. `Monitor` сообщает о завершении, а `Link` может распространять сигнал ошибки.
3. `GenServer` **не перезапускается самостоятельно** — это задача Supervisor.
4. `Supervisor` при рестарте запускает новый процесс, но не возвращает старое состояние автоматически.
5. Стратегии `:one_for_one`, `:one_for_all`, `:rest_for_one` описывают разные способы перезапуска.
6. GC выполняется в основном для каждого процесса отдельно; при передаче больших сообщений между процессами возможны копии данных.
7. Реальная сеть не делает распределённую систему автоматически устойчивой к разделению сети.
