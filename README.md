# TurboTux BBR FQ-CoDel Optimizer

## 🚀 Supercharge Your Network Performance!

Are you tired of sluggish network performance on your Debian-based server? Say hello to the BBR FQ-CoDel Optimizer! This nifty script turbocharges your network by implementing Google's BBR (Bottleneck Bandwidth and Round-trip propagation time) congestion control algorithm alongside the FQ-CoDel (Fair Queuing Controlled Delay) packet scheduler.

### 🌟 Features

- 🔥 Automatically enables BBR congestion control
- 🎛️ Configures FQ-CoDel for improved packet scheduling
- 🔄 Ensures settings persist across reboots
- 🧰 Easy to use - just run and enjoy!

### 🛠️ Requirements

- Debian-based system (tested on Debian Bullseye & Ubuntu Noble Numbat)
- Root access
- Kernel version 4.9+ (5.x recommended for best performance)

### 📦 Installation

1. Clone this repository:

```
git clone https://github.com/ScriptNinja-GNU/TurboTux-BBR-FQ-CoDel-Optimizer.git
```

2. Navigate to the directory:
```
cd TurboTux-BBR-FQ-CoDel-Optimizer
```

3. Make the script executable:
```
chmod +x setup_bbr_fq_codel.sh
```
### 🚀 Usage

Run the script with root privileges:
```
sudo ./setup_bbr_fq_codel.sh
```

Sit back and let the magic happen! The script will:
- Check for BBR availability
- Enable BBR if it's not already active
- Configure sysctl for BBR and FQ-CoDel
- Ensure settings persist after reboot

After running, a system reboot is recommended for changes to take full effect.

### 🤔 Why BBR and FQ-CoDel?

- **BBR**: Google's BBR congestion control can significantly improve throughput and reduce latency, especially on long-distance or lossy network paths.
- **FQ-CoDel**: This packet scheduler helps reduce bufferbloat, ensuring fair queuing and controlled delay for all flows.

Together, they create a powerful combo that can dramatically enhance your network's performance and responsiveness.

### ⚠️ Caution

This script modifies system settings. While it's designed to be safe, it's always a good idea to:
- Backup your system before running
- Test thoroughly in a non-production environment first

### 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/ScriptNinja-GNU/TurboTux-BBR-FQ-CoDel-Optimizer/issues).

### 💖 Show your support

Give a ⭐️ if this project helped you!

## Further Reading

To deepen your understanding of BBR and FQ-CoDel, consider exploring these resources:

1. [BBR: Congestion-Based Congestion Control](https://queue.acm.org/detail.cfm?id=3022184) - The original ACM Queue article by Google researchers introducing BBR.

2. [BBR v2: A Model-based Congestion Control](https://datatracker.ietf.org/meeting/104/materials/slides-104-iccrg-an-update-on-bbr-00) - IETF presentation on BBRv2, discussing improvements and challenges.

5. [Bufferbloat.net](https://www.bufferbloat.net/projects/) - A comprehensive resource on bufferbloat and solutions like FQ-CoDel.

6. [The BSD Packet Filter](https://www.kernel.org/doc/html/latest/networking/filter.html) - Linux kernel documentation on BPF, which is used in modern FQ-CoDel implementations.

These sources provide in-depth technical information on the algorithms and their implementation in modern networks.

---

Remember, with great power comes great responsibility. Use this optimizer wisely, and may your packets always find their way swiftly and surely! 🚀🌐
