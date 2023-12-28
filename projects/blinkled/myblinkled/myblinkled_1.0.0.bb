SUMMARY = "Blink a LED Recipe"
DESCRIPTION = "Recipe to blink a LED"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://myblinkled.service \
           file://myblinkled.c"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} += " myblinkled.service"

DEPENDS = "libgpiod"

inherit systemd

S = "${WORKDIR}"

do_compile () {
	# Specify compilation firmware here
	${CC} ${CFLAGS} ${LDFLAGS} -o myblinkled myblinkled.c -lgpiod
}

do_install () {
	# Specify install firmware here
	install -d ${D}${bindir}
	install -m 0755 myblinkled ${D}${bindir}

	# Specify install service here
	install -d ${D}${systemd_system_unitdir}/
    install -m 0644 myblinkled.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${bindir}/* ${systemd_system_unitdir}/*"