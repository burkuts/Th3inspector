#!/usr/bin/perl

use if $^O eq "MSWin32", Win32::Console::ANSI;
use Getopt::Long;
use HTTP::Request;
use LWP::UserAgent;
use IO::Select;
use HTTP::Headers;
use IO::Socket;
use HTTP::Response;
use Term::ANSIColor;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(GET);
use URI::URL;
use IO::Socket::INET;
use Data::Dumper;
use LWP::Simple;
use JSON qw( decode_json encode_json );

my $ua = LWP::UserAgent->new;
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

GetOptions(
    "h|help" => \$help,
    "i|info=s" => \$site1,
    "n|number=s" => \$PhoneNumber,
    "mx|mailserver=s" => \$site2,
    "w|whois=s" => \$site3,
    "l|location=s" => \$site4,
    "c|cloudflare=s" => \$site5,
    "a|age=s" => \$site6,
    "ua|useragent=s" => \$useragent,
    "p|port=s" => \$target,
    "b|bin=s" => \$bin,
    "s|subdomain=s" => \$site8,
    "e|email=s" => \$email,
    "cms|cms=s" => \$site7,
);

if ($help) { banner();help(); }
if ($site1) { banner();Websiteinformation(); }
if ($PhoneNumber) { banner();Phonenumberinformation(); }
if ($site2) { banner();FindIPaddressandemailserver(); }
if ($site3) { banner();Domainwhoislookup(); }
if ($site4) { banner();Findwebsitelocation(); }
if ($site5) { banner();CloudFlare(); }
if ($site6) { banner();DomainAgeChecker(); }
if ($useragent) { banner();UserAgent(); }
if ($bin) { banner();BIN(); }
if ($site8) { banner();subdomain(); }
if ($email) { banner();email(); }
if ($site7) { banner();cms(); }
if ($target) { banner();port(); }
unless ($help|$site1|$PhoneNumber|$site2|$site3|$site4|$site5|$site6|$useragent|$bin|$email|$site7|$site8|$target) { banner();menu(); }

##### Help #######
sub help {
    print item('1'),"Website Bilgileri";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -i example.com\n";
    print item('2'),"Telefon Numara Bilgisi ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -n xxxxxxx\n";
    print item('3'),"IP Adresi ve E-posta Sunucusu Bulun ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -mx example.com\n";
    print item('4'),"Alan Whois Aramas?? ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -w example.com\n";
    print item('5'),"Web Sitesi/IP Adresi Konumunu Bul ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -l example.com\n";
    print item('6'),"Bypass CloudFlare ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -c example.com\n";
    print item('7'),"Alan Ad?? Ya????n?? Bulma ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -a example.com\n";
    print item('8')," Kullan??c?? Bilgisi";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -ua Mozilla/5.0 xxxxxxxxxxxxxxxxxxxx\n";
    print item('9'),"Kaynakta Etkin Hizmetleri Kontrol Edin";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -p 127.0.0.1\n";
    print item('10'),"Kredi Kart?? B??N Bilgisi Bulma ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -b 123456\n";
    print item('11'),"Subdomain Bulucu ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -s example.com\n";
    print item('12'),"E-mail Adres Denetleyicisi ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -e example@gmail.com\n";
    print item('13'),"????erik Y??netim Sistemi Denetleyicisi ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -cms example.com\n";
}

##### Banner #######
sub banner {
    if ($^O =~ /MSWin32/) {system("mode con: cols=100 lines=29");system("cls"); }else { system("resize -s 28 87");system("clear"); }
    print "         ,;;;,     \n";
    print "        ;;;;;;;                   \n";
    print "     .- `\\, '/_      _____ _    ";
    print color('bold red'),"____";
    print color('reset');
    print "  _                      _            \n";
    print "   .'   \\  (`(_)    |_   _| |_ ";
    print color('bold red'),"|__ /";
    print color('reset');
    print " (_)_ _  ____ __  ___ __| |_ ___ _ _ \n";
    print "  / `-,. \\ \\_/        | | | ' \\ ";
    print color('bold red'),"|_ \\";
    print color('reset');
    print "\ | | ' \\(_-< '_ \\/ -_) _|  _/ _ \\ '_| \n";
    print "  \\  \\/ \\ `--`        |_| |_||_|";
    print color('bold red'),"___/";
    print color('reset');
    print " |_|_||_/__/ .__/\\___\\__|\\__\\___/_| ";
    print color('bold green'),"V 1.9\n";
    print color('reset');
    print "   \\  \\  \\                         \033[0;31m[\033[0;33m127.0.0.1\033[0;31m] \033[0;37m|_|\033[0;31m [\033[1;34m192.168.1.1\033[0;31m] \033[0;37m\n";
    print "    / /| |                            \033[0;31m[\033[0;37mYazar Mohamed Riahi\033[0;31m]\033[0;37m\n";
    print "   /_/ |_|      \n";
    print "  ( _\\ ( _\\    #:##       #:##\n";
    print "                     #:## \n\n";
}

##### Menu #######
sub menu {
    print item('01'),"Website Bilgisi\n";
    print item('02'),"Telefon Numara Bilgisi\n";
    print item('03'),"IP Adresi ve E-posta Sunucusu Bulun\n";
    print item('04'),"Domain Whois Aramas??\n";
    print item('05'),"Website/??P Adresi Lokasyon Bulucu\n";
    print item('06'),"Bypass CloudFlare\n";
    print item('07'),"Alan Ad?? Ya?? Bulma\n";
    print item('08'),"Kullan??c?? Bilgi Bulma\n";
    print item('09'),"Kaynakta Etkin Hizmetleri Kontrol Edin\n";
    print item('10'),"Kredi Kart?? B??N Bilgisini Bulma\n";
    print item('11'),"Subdomain Bulucu\n";
    print item('12'),"E-posta Adresini Kontrol Edin\n";
    print item('13'),"????erik Y??netim Sistemi Denetleyicisi\n";
    print item('14'),"G??ncelle\n\n";
    print item('-'),"Se?? : ";
    print color('reset');

    chomp($number=<STDIN>);

    if($number eq '01'){
        banner();
        print item(),"Web Site Girin : ";
        chomp($site1=<STDIN>);
        banner();
        Websiteinformation();
        enter();
    }if($number eq '02'){
        banner();
        print item(),"Telefon Numaras?? Girin (??lke Kodu ??le Beraber) : +";
        chomp($PhoneNumber=<STDIN>);
        banner();
        Phonenumberinformation();
        enter();
    }if($number eq '03'){
        banner();
        print item(),"Website Girin : ";
        chomp($site2=<STDIN>);
        banner();
        FindIPaddressandemailserver();
        enter();
    }if($number eq '04'){
        banner();
        print item(),"Website Girin : ";
        chomp($site3=<STDIN>);
        banner();
        Domainwhoislookup();
        enter();
    }if($number eq '05'){
        banner();
        print item(),"Website/??P Girin : ";
        chomp($site4=<STDIN>);
        banner();
        Findwebsitelocation();
        enter();
    }if($number eq '06'){
        banner();
        print item(),"Website Girin : ";
        chomp($site5=<STDIN>);
        banner();
        CloudFlare();
        enter();
    }if($number eq '07'){
        banner();
        print item(),"Website Girin : ";
        chomp($site6=<STDIN>);
        banner();
        DomainAgeChecker();
        enter();
    }if($number eq '08'){
        banner();
        print item(),"Kullan??c?? girin : ";
        chomp($useragent=<STDIN>);
        my $find = "/";
        my $replace = "%2F";

        $find = quotemeta $find;
        $useragent =~ s/$find/$replace/g;
        $useragent =~ s/ /+/g;
        banner();
        UserAgent();
        enter();
    }if($number eq '09'){
        banner();
        port();
        enter();
    }if($number eq '10'){
        banner();
        print item(),"Kredi Kart?? Numaras??n??n ??lk 6 Basama????n?? Girin : ";
        chomp($bin=<STDIN>);
        banner();
        BIN();
        enter();
    }if($number eq '11'){
        banner();
        print item(),"Website Girin: ";
        chomp($site8=<STDIN>);
        banner();
        subdomain();
        enter();
    }if($number eq '12'){
        banner();
        print item(),"E-Mail adresi Girin : ";
        chomp($email=<STDIN>);
        banner();
        email();
        enter();
    }if($number eq '13'){
        banner();
        print item(),"Website Girin: ";
        chomp($site7=<STDIN>);
        banner();
        cms();
        enter();
    }if($number eq '14'){
        update();
    }
}

####### Website information #######
sub Websiteinformation {
    $url = "https://myip.ms/$site1";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/> (.*?) visitors per day </)
    {
        print item(),"Website ??le Alakal?? Hosting Bilgisi: $site1\n";
        print item(),"Visitors per day: $1 \n";

        if($response =~/> (.*?) visitors per day on (.*?)</){
            print item(),"G??nl??k Ziyaret??i: $1 \n";
        }
        $ip= (gethostbyname($site1))[4];
        my ($a,$b,$c,$d) = unpack('C4',$ip);
        $ip_address ="$a.$b.$c.$d";
        print item(),"??P Adresi: $ip_address\n";

        if($response =~/IPv6.png'><a href='\/info\/whois6\/(.*?)'>/)
        {
            $ipv6_address=$1;
            print item(),"Ba??l?? IPv6 Adresi: $ipv6_address\n";
        }
        if($response =~/Ip Location: <\/td> <td class='vmiddle'><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/Internet_Usage_Statistics_(.*?).html'>(.*?)<\/a>/)
        {
            $Location=$1;
            print item(),"??P Lokasyonu: $Location\n";
        }
        if($response =~/IP Reverse DNS (.*?)<\/b><\/div><div class='sval'>(.*?)<\/div>/)
        {
            $host=$2;
            print item(),"??P Ters DNS (Host): $host\n";
        }
        if($response =~/Hosting Company: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerName=$1;
            print item(),"Hosting/Bar??nd??rma ??irketi: $ownerName\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'>  <span class='cflag (.*?)'><\/span> <a href='\/view\/web_hosting\/(.*?)'>(.*?)<\/a>/)
        {
            $ownerip=$3;
            print item(),"Bar??nd??rma ??irketi IP Sahibi:  $ownerip\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerip=$1;
            print item(),"Bar??nd??rma ??irketi IP Sahibi:  $ownerip\n";
        }
        if($response =~/IP Range <b>(.*?) - (.*?)<\/b><br>have <b>(.*?)<\/b>/)
        {
            print item(),"IP Aral?????? Bar??nd??rma: $1 - $2 ($3 ip) \n";
        }
        if($response =~/Hosting Address: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $address=$1;
            print item(),"Hosting Adresi: $address\n";
        }
        if($response =~/Owner Address: <\/td><td>(.*?)<\/td>/)
        {
            $addressowner=$1;
            print item(),"Sahibin Adresi: $addressowner\n";
        }
        if($response =~/Hosting Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $HostingCountry=$1;
            print item(),"Bar??nd??rd?????? ??lke: $HostingCountry\n";
        }
        if($response =~/Owner Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $OwnerCountry=$1;
            print item(),"Sahibin ??lkesi: $OwnerCountry\n";
        }
        if($response =~/Hosting Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $phone=$1;
            print item(),"Bar??nd??rma ??irketinin Telefonu: $phone\n";
        }
        if($response =~/Owner Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $Ownerphone=$1;
            print item(),"Sahibin Telefonu: $Ownerphone\n";
        }
        if($response =~/Hosting Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/images\/tooltip.gif'><\/td><td><a href='\/(.*?)'>(.*?)<\/a><\/td>/)
        {
            $website=$1;
            print item(),"Hosting'in Sitesi: $website\n";
        }
        if($response =~/Owner Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/(.*?)'><\/td><td><a href='\/(.*?)'>(.*?)<\/a>/)
        {
            $Ownerwebsite=$3;
            print item(),"Sahibin Sitesi: $Ownerwebsite\n";
        }
        if($response =~/CIDR:<\/td><td> (.*?)<\/td><\/tr>/)
        {
            $CIDR=$1;
            print item(),"CIDR: $CIDR\n";
        }
        if($response =~/Owner CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Sahip CIDR: $3/$4\n\n";
        }
        if($response =~/Hosting CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Bar??nd??r??lan CIDR: $3/$4\n\n";
        }
        $url = "https://dns-api.org/NS/$site1";
        $request = $ua->get($url);
        $response = $request->content;
    }else {
        print item(),"Bir Sorun Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Web Sitesine HTTP/HTTPS Olmadan Girin\n";
        print item('3'),"Web Sitesinin ??al??????p ??al????mad??????n?? Kontrol Edin\n";
    }
    my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS: $ns \n";
    }
}

### Phone number information ###########
sub Phonenumberinformation {

    $url = "https://pastebin.com/raw/egbm0eEk";
    $request = $ua->get($url);
    $api2 = $request->content;

    $url = "http://apilayer.net/api/validate?access_key=$api2&number=$PhoneNumber&country_code=&format=1";
    $request = $ua->get($url);
    $response = $request->content;
    if($response =~/"valid":true/)
    {
        $valid=$1;
        print item(),"Ge??erli : ";
        print color("bold green"),"true\n";

        if($response =~/local_format":"(.*?)"/)
        {
            $localformat=$1;
            print item(),"Yerel Bi??im : $localformat\n";
        }
        if($response =~/international_format":"(.*?)"/)
        {
            $international_format=$1;
            print item(),"Uluslar Aras?? Bi??im : $international_format\n";
        }
        if($response =~/country_name":"(.*?)"/)
        {
            $country_name=$1;
            print item(),"??lke : $country_name\n";
        }
        if($response =~/location":"(.*?)"/)
        {
            $location=$1;
            print item(),"Lokasyon : $location\n";
        }
        if($response =~/carrier":"(.*?)"/)
        {
            $carrier=$1;
            print item(),"Ta????y??c?? : $carrier\n";
        }
        if($response =~/line_type":"(.*?)"/)
        {
            $line_type=$1;
            print item(),"??izgi T??r?? : $line_type\n";
        }
    }else {
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Telefon Numaras??n?? + Olmadan Girin/00\n";
        print item('3'),"Telefon Numaras??n??n Var Olup Olmad??????n?? Kontrol Edin\n";
        exit
    }
}
### Find IP address and email server ###########
sub FindIPaddressandemailserver {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0");
    my $url = "https://dns-api.org/MX/$site2";

    $request = $ua->get($url);
    $response = $request->content;
    if ($response =~ /error/){
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websitesini HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Web Sitesinin ??al??????p ??al????mad??????n?? Kontrol Edin\n";
        exit
    }
    print item(),"Alan Ad??n??n MX Kayd??na Bak??n: $site2\n\n";
    my %seen;
   while($response =~m/"value": "(.*?)."/g)
    {
        $mx=$1;
        next if $seen{$mx}++;
        print item(),"MX: $mx \n";
    }
}
### Domain whois lookup ###########
sub Domainwhoislookup {
    $url = "https://pastebin.com/raw/YfHdX0jE";
    $request = $ua->get($url);
    $api4 = $request->content;
    $url = "http://www.whoisxmlapi.com//whoisserver/WhoisService?domainName=$site3&username=$api4&outputFormat=JSON";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);

    if (exists $responseObject->{'WhoisRecord'}->{'createdDate'}){
        print item(),"Whois aramas?? : $site3 \n";
        print item(),' : ',
        $responseObject->{'WhoisRecord'}->{'createdDate'},"\n";sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'expiresDate'}){
            print item(),'Son Kullanma Tarihi: ',
            $responseObject->{'WhoisRecord'}->{'expiresDate'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'contactEmail'}){
            print item(),'??leti??im E-Maili: ',
            $responseObject->{'WhoisRecord'}->{'contactEmail'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'name'}){
            print item(),'Kay??t Sahibinin Ad??: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'name'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'}){
            print item(),'Kay??t Eden Organizasyon: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'}){
            print item(),'Kay??t Edilen Adres: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'city'}){
            print item(),'Kay??t Edilen ??ehir: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'state'}){
            print item(),' Kay??tl?? B??lge: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'}){
            print item(),'Kay??tl?? Posta Kodu: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'country'}){
            print item(),'Kay??tl?? ??lke: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'email'}){
            print item(),' Kay??tl?? E-mail ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'}){
            print item(),'Kay??tl?? Telefon: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'}){
            print item(),'Kay??tl?? Fax ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'}){
            print item(),'Admin' ??smi: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'}){
            print item(),'Admin Organizasyonu: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'}){
            print item(),'Admin Adresi: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'}){
            print item(),'Admin ??ehri: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'}){
            print item(),'Admin B??lgesi: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'}){
            print item(),'Admin Posta Kodu: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'}){
            print item(),'Admin ??lkesi: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'}){
            print item(),'Admin Email: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'}){
            print item(),'Admin Telefonu: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'}){
            print item(),'Admin Fax: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'}){
            print item(),'Teknik Sorumlunun ??smi: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'}){
            print item(),'Teknik Sorumlunun Organizasyonu: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'}){
            print item(),'Teknik Sorumlunun Adresi: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'}){
            print item(),'Teknik Sorumlunun ??ehri: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'}){
            print item(),'Teknik Sorumlunun B??lgesi: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'}){
            print item(),'Teknik Sorumlunun Posta Kodu: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'}){
            print item(),'Teknik Sorumlunun ??lkesi: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'}){
            print item(),'Teknik Sorunlunun Emaili: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'}){
            print item(),'Teknik Sorumlunun Telefonu: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'}){
            print item(),'Teknik Soeumlunun FAX??: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'},"\n";}sleep(1);
    }else {
        print item(),"Bir Sorun Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Web Sitesinin ??al??????p ??al????mad??????n?? Kontrol Edin\n";
    }
}
### Find website location ###########
sub Findwebsitelocation {
    $ip= (gethostbyname($site4))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip ="$a.$b.$c.$d";

    $url = "https://ipapi.co/$ip/json/";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/country_name": "(.*?)"/){
        print item(),"IP Adresi: $ip\n";
        print item(),"??lke: $1\n";
        if($response =~/city": "(.*?)"/){
            print item(),"??ehie: $1\n";
        }if($response =~/region": "(.*?)"/){
            print item(),"B??lge: $1\n";
        }if($response =~/region_code": "(.*?)"/){
            print item(),"B??lge Kodu: $1\n";
        }if($response =~/continent_code": "(.*?)"/){
            print item(),"K??ta kodu: $1\n";
        }if($response =~/postal": "(.*?)"/){
            print item(),"Posta Kodu: $1\n";
        }if($response =~/latitude": (.*?),/){
            print item(),"Enlem/Boylam: $1, ";
        }if($response =~/longitude": (.*?),/){
            print color("kal??n beyaz"),"$1\n";
        }if($response =~/timezone": "(.*?)"/){
            print item(),"Zaman Dilimi: $1\n";
        }if($response =~/utc_offset": "(.*?)"/){
            print item(),"Utc Offset: $1\n";
        }if($response =~/country_calling_code": "(.*?)"/){
            print item(),"Arama Kodu: $1\n";
        }if($response =~/currency": "(.*?)"/){
            print item(),"Para Birimi: $1\n";
        }if($response =~/languages": "(.*?)"/){
            print item(),"Dil: $1\n";
        }if($response =~/asn": "(.*?)"/){
            print item(),"ASN: $1\n";
        }if($response =~/org": "(.*?)"/){
            print item(),"ORG: $1\n";
        }
    }else {
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Web Sitesinin/IP'nin ??al??????p ??al????mad??????n?? Kontrol Edin\n";
    }
}
### Bypass CloudFlare ###########
sub CloudFlare {
    my $ua = LWP::UserAgent->new;
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $ip= (gethostbyname($site5))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($ip_address =~ /[0-9]/){
        print item(),"CloudFlare IP: $ip_address\n\n";
    }

    $url = "https://dns-api.org/NS/$site5";
    $request = $ua->get($url);
    $response = $request->content;

my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS / Name Server: $ns \n";
    }
    print color("bold white"),"\n";
    $url = "http://www.crimeflare.us/cgi-bin/cfsearch.cgi";
    $request = POST $url, [cfS => $site5];
    $response = $ua->request($request);
    $riahi = $response->content;

    if($riahi =~m/">(.*?)<\/a>&nbsp/g){
        print item(),"Ger??ek ??P: $1\n";
        $ip=$1;
    }elsif($riahi =~m/not CloudFlare-user nameservers/g){
        print item(),"Bunlar CloudFlare Kullan??c?? Name Serverlar?? De??ildir !!\n";
        print item(),"Bu Web Sitesi CloudFlare Korumas??n?? Kullanm??yor\n";
    }elsif($riahi =~m/No direct-connect IP address was found for this domain/g){
        print item(),"Bu Etki Alan?? ????in Do??rudan Ba??lant?? IP Adresi Bulunamad??\n";
    }else{
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Websitenin ??al??????p ??al????mad??????n?? ????renin\n";
    }

    $url = "http://ipinfo.io/$ip/json";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/hostname": "(.*?)"/g){
        print item(),"Hostname: $1\n";
    }if($response =~m/city": "(.*?)"/g){
        print item(),"??ehir: $1\n";
    }if($response =~m/region": "(.*?)"/g){
        print item(),"B??lge: $1\n";
    }if($response =~m/country": "(.*?)"/g){
        print item(),"??lke: $1\n";
    }if($response =~m/loc": "(.*?)"/g){
        print item(),"Lokasyon: $1\n";
    }if($response =~m/org": "(.*?)"/g){
        print item(),"Organizasyon: $1\n";
    }
}



### User Agent Info ###########
sub UserAgent {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $url = "https://pastebin.com/raw/pTXVQiuJ";
    $request = $ua->get($url);
    $api8 = $request->content;

    $url = "https://useragentapi.com/api/v4/json/$api8/$useragent";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/ua_type":"(.*?)"/g){
        print item(),"User T??r??: $1\n";
        if($response =~m/os_name":"(.*?)"/g){
            print item(),"????letim Sisteminin ??smi: $1\n";
        }if($response =~m/os_version":"(.*?)"/g){
            print item(),"????letim Sisteminin Versiyonu: $1\n";
        }if($response =~m/browser_name":"(.*?)"/g){
            print item(),"Taray??c?? ??smi: $1\n";
        }if($response =~m/browser_version":"(.*?)"/g){
            print item(),"Taray??c?? Versiyonu: $1\n";
        }if($response =~m/engine_name":"(.*?)"/g){
            print item(),"Motor Ad??ion1\n";
        }if($response =~m/engine_version":"(.*?)"/g){
            print item(),"Motor Versiyonu $1\n";
        }
    }else{
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"User Olup Olmad??????n?? Kontrol Edin\n";
    }
}

### Domain Age Checker ###########
sub DomainAgeChecker {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $url = "https://input.payapi.io/v1/api/fraud/domain/age/$site6";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/is (.*?) days (.*?) Date: (.*?)"/g){
        $days=$1;
        $created=$3;

        print item(),"Alan Ad?? ??smi : $site6\n";
        print item(),"Alan Ad??n??n Olu??turulma Tarihi : $created\n";

        $url = "http://unitconverter.io/days/years/$days";
        $request = $ua->get($url);
        $response = $request->content;

        if($response =~m/<strong style="color:red"> = (.*?)<\/strong><\/p>/g){
            $age=$1;
            $age =~ s/  / /g;
            print item(),"Alan Ad?? Ya???? : $age\n";
        }
    }else{
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Websitenin Olup Olmad??????n?? Kontrol Edin\n";
    }
}
######################## Credit card BIN number Check ################################
sub BIN {
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

$url = "https://lookup.binlist.net/$bin";
$request = $ua->get($url);
$response = $request->content;
 
if($response =~/scheme/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Kredi Kart?? B??N Numaras??: $bin XX XXXX XXXX\n";
if($response =~/scheme":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Kredi Kart?? Markas??: $1\n";
}if($response =~/type":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"T??r??: $1\n";
}if($response =~/name":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Banka: $1\n";
}if($response =~/url":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Banka URLsi: $1\n";
}if($response =~/phone":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Banka Telefonu: $1\n";
}if($response =~/alpha2":"(.*?)","name":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"??lke K??sa: $1\n";    
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"??lke: $2\n";
}if($response =~/latitude":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enlem: $1\n";
}if($response =~/longitude":"(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Boylam: $1\n";
}
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Bir Problem Var\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Ba??lant?? Kontrol Ediliyor\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Kredi Kart??n??n ailk 6 Hanesini Girin\n";
}
}
####### Subdomain Scanner #######
sub subdomain {
    $url = "https://www.pagesinventory.com/search/?s=$site8";
    $request = $ua->get($url);
    $response = $request->content;

    $ip= (gethostbyname($site8))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($response =~ /Search result for/){
        print item(),"Website: $site8\n";
        print item(),"IP: $ip_address\n\n";

        while($response =~ m/<td><a href=\"\/domain\/(.*?).html\">(.*?)<a href="\/ip\/(.*?).html">/g ) {

            print item(),"Alt Alan Ad??: $1\n";
            print item('-'),"??P: $3\n\n";
            sleep(1);
        }
    }elsif($ip_address =~ /[0-9]/){
        if($response =~ /Sonu?? Yok/){
            print item(),"Website: $site8\n";
            print item(),"??P: $ip_address\n\n";
            print item(),"Bu Alan Ad?? ????in Alt Alan Bulunamad??\n";
        }}else {
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Girin\n";
        print item('3'),"Websitenin Olup Olmad??????na Bakin\n";
    }
}

####### Port scanner #######
sub port {
    print item(),"Website/??P Adresi Girin : ";

    chop ($target = <stdin>);
    $| = 1;

    print "\n";
    print item(),"PORT  DEVLET  H??ZMET??\n";
    my %ports = (
        21   => 'FTP'
        ,22   => 'SSH'
        ,23   => 'Telnet'
        ,25   => 'SMTP'
        ,43   => 'Whois'
        ,53   => 'DNS'
        ,68   => 'DHCP'
        ,80   => 'HTTP'
        ,110  => 'POP3'
        ,115  => 'SFTP'
        ,119  => 'NNTP'
        ,123  => 'NTP'
        ,139  => 'NetBIOS'
        ,143  => 'IMAP'
        ,161  => 'SNMP'
        ,220  => 'IMAP3'
        ,389  => 'LDAP'
        ,443  => 'SSL'
        ,1521 => 'Oracle SQL'
        ,2049 => 'NFS'
        ,3306 => 'mySQL'
        ,5800 => 'VNC'
        ,8080 => 'HTTP'
    );
    foreach my $p ( sort {$a<=>$b} keys( %ports ) )
    {
        $socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => "$p" , Proto => 'tcp' , Timeout => 1);
        if( $socket ){
            print item(); printf("%4s  A????k    %s\n", $p, $ports{$p});

        }else{
            print item(); printf("%4s  Kapal??  %s\n", $p, $ports{$p});
        }
    }
}

####### Check e-mail address #######
sub email {
    $url = "https://api.2ip.me/email.txt?email=$email";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/true/)
    {
        print item(),"E-mail Adresi : $email \n";
        print item(),"Ge??erli : ";
        print color('bold green'),"EVET\n";
        print color('reset');
    }elsif($response =~/false/){
        print item(),"E-mail adresi : $email \n";
        print item(),"Ge??erli : ";
        print color('bold red'),"HAYIR\n";
        print color('reset');
    }else{
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"E-postan??n Mevcut Olup Olmad??????n?? Kontrol Edin\n";
    }
}

####### Check Content Management System (CMS) #######
sub cms {
    $url = "https://pastebin.com/raw/CYaZrPFP";
    $request = $ua->get($url);
    $api12 = $request->content;

    $url = "https://whatcms.org/APIEndpoint?key=$api12&url=$site7";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);

    if($response =~/Success/){
        print item(),"WebSite : $site7 \n";
        if (exists $responseObject->{'result'}->{'name'}){
            print item(),'CMS: ',
            $responseObject->{'result'}->{'name'},"\n";}
        if (exists $responseObject->{'result'}->{'version'}){
            print item(),'Versiyon: ',
            $responseObject->{'result'}->{'version'},"\n";}
    }elsif($response =~/CMS Not Found/){
        print item(),"WebSite : $site7 \n";
        print item(),"CMS :";
        print color("bold red")," Sonu?? Yok\n";
        print color('reset');
    }else{
        print item(),"Bir Problem Var\n\n";
        print item('1'),"Ba??lant?? Kontrol Ediliyor\n";
        print item('2'),"Websiteyi HTTPS/HTTP Olmadan Giriniz\n";
        print item('3'),"Websitenin Olup Olmad??????n?? Kontrol Edin\n";
    }
}


##### Update #######
sub update {
    if ($^O =~ /MSWin32/) {
        banner();
        print item('1'),"Th3inspector ??ndir\n";
        print item('2'),"Th3inspector'?? Masa??st??ne ????kar??n\n";
        print item('3')," CMD'yi a????n ve a??a????daki komutlar?? yaz??n:\n";
        print item('4'),"cd Desktop/Th3inspector-master/\n";
        print item('5'),"perl Th3inspector.pl\n";
    }else {
        $linux = "/usr/share/Th3inspector";
        $termux = "/data/data/com.termux/files/usr/share/Th3inspector";
        if (-d $linux){
            system("bash /usr/share/Th3inspector/update.sh");
        } elsif (-d $termux){
            system("chmod +x /data/data/com.termux/files/usr/share/Th3inspector/update.sh && bash /data/data/com.termux/files/usr/share/Th3inspector/update.sh");
        }
    }
}
##### Enter #######
sub enter {
    print "\n";
    print item(),"Bas??n ";
    print color('bold red'),"[";
    print color("bold white"),"G??R????";
    print color('bold red'),"] ";
    print color("bold white"),"Devam Etmek ????in Anahtar\n";

    local( $| ) = ( 1 );

    my $resp = <STDIN>;
    banner();
    menu();
}

### Item format ###
sub item
{
    my $n = shift // '+';
    return color('bold red')," ["
    , color('bold green'),"$n"
    , color('bold red'),"] "
    , color("bold white")
    ;
}
__END__
