# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-utils-2 toolchain-funcs

DESCRIPTION="Visualization and manually annotating whole genomes"
HOMEPAGE="http://www.broadinstitute.org/annotation/argo2
	http://www.broadinstitute.org/annotation/argo"
SRC_URI="http://www.broadinstitute.org/annotation/argo2/releases/argo2.jar"
#
# Release Number: 3
# Release Date:   2010-06-23

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!sci-biology/argo"
RDEPEND="${DEPEND}
		>=virtual/jre-1.5:*"
S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}"/argo2.jar argo2.jar
	java-pkg_dolauncher
}
