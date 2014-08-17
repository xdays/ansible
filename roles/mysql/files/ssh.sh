#!/bin/sh
# -*- coding: utf-8 -*-
 
umask 0077 

if [ ! -e /root/.ssh ];then
    mkdir /root/.ssh
fi
cat > /root/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUds6UuLnoW4Sgn7lbdDvl8M9GRrVjGoY/TE8xi+nvi+mkPxKRK6H6CLB8T0LxlcxqPaH/gXcWwRsx7mxoTtpDL49eDwui1MWtN4E6tsU8kvAdpR5dDy9yTng6XtRh5DxzVisHaL3Wq0Op9M1oiDiShtiZiwnzC3jSqO8gzhF5cvJKkE8GQusTeuORiu85NPqZY6+1vxwE6H1a2m9XS/f8xmdfJjaUJQjnRJnlBO536YeklLF50d1d8/hs8J2k0+EGWgefkcs5IvSDp+dAKj2NICmFHpcEmByY4wuQllnnnqaIQaSxgoO/JNKBvlnyMO5J3asHqxE6pE87wVkYcSaP xdays@xdays-ThinkPad-E520
ssh-dss AAAAB3NzaC1kc3MAAACBAJboXurDc0JbQt1DqMXHfT5ZEToTBHEtRwxx/FnL7m74xaiHmSeWJLaXzYz9h6+fVYLzzL69iPjIchHYiSu24IIKaEur/cmOS2mOFMeuJnvl7GhxinY3rMh8JUb+DPMheQ9CrPJdlDbTWvwbUZCD7ZPQLOevNxWN3uNjxDQIkzCRAAAAFQCWqPu/cDS+B2DNcG2nzcnjL5rtAQAAAIBoNfgSUbRBkH/XihuccFNdC5rYhSjKLn/aL7KISYFy6qhAXm/jwI5CR5j7Mx3M1OwltF/+1dzJm1bqTpgHzQvkhDPZAAmpQ0CFergmjSY4eZdmDiTIuCHIxITdPYULQQ3Jl/y75vj8dn3apMAT2bmqaWOvpGNHora7SruaicbBkwAAAIB7UDa3QELiSwQHCB4osqQBh7sbwaHOT5Lsd9cig09qGrc7xui264PuBGaBBjzyuZQPqiXlrpMivaxeHaj0UeYrzTlAaoWPp9Q/JTrEIYO7/xZatX6TVaXyOdDfiqK0kYGNdwFb1nmHYyUQC8NTxqWuLj8G3lcG168fGFZauPeHLg== ahua@localhost
EOF

sed -i 's/#Port 22/Port 65422/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
/etc/init.d/sshd restart
