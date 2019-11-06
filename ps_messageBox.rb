##################
#2019/10/13/18:43#
##################

class MetasploitModule < Msf::Post
  include Msf::Post::Windows::Powershell

  def initialize(info = {})
    super(
      update_info(
        info,
        'Name'          => 'PowerShell MessageBox',
        'Description'   => %q(
          This module can show a PowerShell Message box.
        ),
        'License'       => MSF_LICENSE,
        'Author'        => ['AirEvan'],
        'Platform'      => ['win']
      )
    )

    register_options(
      [
        OptString.new('TITLE', [true, 'Messagebox Title',"Hello"]),
        OptString.new('TEXT',[true, 'Messagebox Text',"Metasploit"]),
        OptString.new('ICON',[true, 'Messagebox Icon',"Info"]),
        OptString.new('DURATION',[true, 'Messagebox duration',"1000"])
      ])
  end
  def showMsgbox(title,text,icon,time)
    script = %(
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
$balloon = New-Object System.Windows.Forms.NotifyIcon
$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balloon.Icon = $icon
$balloon.BalloonTipIcon = "#{icon}"
$balloon.BalloonTipText = "#{text}"
$balloon.BalloonTipTitle = "#{title}"
$balloon.Visible = $true
$balloon.ShowBalloonTip("#{time}")
	)
    psh_exec(script,false,false)
  end
  def run
    msgTitle = datastore['TITLE']
    msgText = datastore['TEXT']
    msgIcon = datastore['ICON']
    msgTime = datastore['TIME']
    print_good("Target PowerShell Version is:#{get_powershell_version}")
    showMsgbox(msgTitle, msgText, msgIcon,msgTime)
  end
end


