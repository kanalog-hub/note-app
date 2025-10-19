export const metadata = {
  title: 'Note App',
  description: 'モダンコーディング学習用ノートアプリ',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  )
}
