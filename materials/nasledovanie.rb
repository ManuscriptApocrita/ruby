class Device
  def initialize(serial_number, manufacturer)
    @serial_number = serial_number
    @manufacturer = manufacturer
  end

  def information_exchange_interface(interface)
    puts "interfaces for information exchange: #{interface}"
  end
end

class  Phone < Device #демонстрация наследования, класс "Телефон" копирует структуру "Устройства", и каждый телефон, обязательно, должен обладать серийным номером и производителем
  def initialize(serial_number, manufacturer, model, resolution, memory, battery)
    super(serial_number, manufacturer)
    @model = model #демонстрация полиморфизма, подкласс меняет свою структуру и предстает в новом обличии
    @resolution = resolution
    @memory = memory
    @battery = battery
  end

  def general_info
    puts "manufacturer: #{@manufacturer}"
    puts "MODEL: #{@model}\nRESOLUTION: #{@resolution}\nMEMORY: #{@memory}\nBATTERY: #{@battery}"
    puts "serial number - #{@serial_number}"
  end

  def information_exchange_interface(names)
    super(names)
  end
end

oppo_a57 = Phone.new("3ES014CC71", "OPPO", "A57S", "1612 x 720 (HD+)", "RAM 4GB, ROM 64GB", "5000 mAh")

oppo_a57.general_info
oppo_a57.information_exchange_interface("USB, Bluetooth, Wi-Fi")