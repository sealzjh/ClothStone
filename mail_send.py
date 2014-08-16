# -*- coding: utf8 -*-

import sys

def sendMail(obj):
    print obj
    targetMailAddress=obj[1]
    subject=obj[2]
    msgContext=obj[3]

    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart
    msg = MIMEMultipart()
    msg["From"] = "notice@imdada.cn"
    msg["To"] = targetMailAddress
    msg["Subject"] = subject
    text = MIMEText(msgContext,'html','utf-8')
    msg.attach(text)
    smtp = connectToSMTPServer()
    print "prepare to send mail"
    smtp.sendmail(msg["From"],msg["To"],msg.as_string())
    smtp.quit()

def connectToSMTPServer():
    import smtplib,mimetypes
    smtp=smtplib.SMTP()
    smtp.connect("smtp.exmail.qq.com")
    smtp.login("notice@imdada.cn","dada13579")
    return smtp

sendMail(sys.argv)

