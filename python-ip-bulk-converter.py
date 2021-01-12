'''
Gunakan script ini untuk mengkonversi IP range ke IP tunggal
untuk selanjutnya dapat menggunakan tools httprobe/httpx untuk melakukan check service web
'''

import ipaddress
import netaddr

filename = "list-ip.txt"

with open(filename) as f:
    list_ip = f.read().splitlines()
    f.close()
    
opt = open("list_ip_all.txt", "a")

counter=0
for ip_addr in list_ip:
    for host in netaddr.IPNetwork(ip_addr):
        counter+=1
        opt.write(str(host)+"\n")

opt.close()
print("[+] Done check list_ip_all.txt")
print("[+] Total : "+ str(counter) +" Hosts")
    
