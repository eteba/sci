# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fortran versionator multilib

MY_P="${PN}_$(replace_version_separator 2 '-')"

DESCRIPTION="The CFD General Notation System (CGNS) is a standard for CFD data."
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/cgns/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran hdf5 szip zlib"

DEPEND="hdf5? ( sci-libs/hdf5 )
	zlib? ( sys-libs/zlib )
	szip? ( sci-libs/szip )"

RDEPEND="${DEPEND}"

MY_S="${PN}_$(get_version_component_range 1-2)"
S="${WORKDIR}"/"${MY_S}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch

	use hdf5 && epatch "${FILESDIR}"/${P}_hdf5.patch
}

src_configure() {
	local myconf="--enable-gcc --enable-lfs --enable-shared=all --enable-64bit"

	econf \
		${myconf} \
		$(use_with fortran) \
		$(use_with hdf5) \
		$(use_with zlib) \
		$(use_with szip)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	fperms 755 /usr/bin/{hdf2adf,adf2hdf}
}
