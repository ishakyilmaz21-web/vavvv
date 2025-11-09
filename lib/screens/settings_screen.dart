import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _SectionTitle("Genel"),
        SwitchListTile(
          value: true, onChanged: null, // örnek
          title: Text("Koyu Tema (üstteki güneş ikonunu kullan)"),
        ),
        ListTile(
          leading: Icon(Icons.language),
          title: Text("Dil Seçimi"),
          subtitle: Text("Türkçe"),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(),
        _SectionTitle("Bildirimler"),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Namaz Bildirimleri"),
          subtitle: Text("Her vakit için ayrı ayrı süre ayarla (yakında)"),
        ),
        Divider(),
        _SectionTitle("Destek"),
        ListTile(
          leading: Icon(Icons.mail_outline),
          title: Text("Öneri & Destek Gönder"),
          subtitle: Text("destek@ezanvaktiplus.app"),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
