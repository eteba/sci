# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-apache-bcel dev-java/testng:0 ant-junit4"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java-based command-line utilities that manipulate SAM/BAM/CRAM/VCF files"
HOMEPAGE="http://picard.sourceforge.net
	http://broadinstitute.github.io/picard"
#SRC_URI="https://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"
SRC_URI="https://github.com/broadinstitute/picard/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0" # 2.2.2 is MIT instead, not sure when it changed away from Apache
SLOT="0"
IUSE=""
KEYWORDS=""

CDEPEND="dev-java/snappy:1.0
	dev-java/cofoja:0
	dev-java/commons-jexl:2
	dev-java/ant-core:0"

DEPEND=">=virtual/jdk-1.7
	dev-java/ant-apache-bcel:0
	test? (
		dev-java/testng:0
		dev-lang/R
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

EANT_BUILD_TARGET="all"
EANT_TEST_TARGET="test"
EANT_NEEDS_TOOLS="true"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="snappy-1.0,cofoja,commons-jexl-2,ant-core"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},testng"

java_prepare() {
	mkdir -p "${S}"/lib || die

	# TODO: update the patch
	#epatch "${FILESDIR}"/${PV}-gentoo.patch

	mv "${S}"/src/java/net/sf/samtools/SAMTestUtil.java "${S}"/src/tests/java/net/sf/samtools || die
}

src_install() {
	cd dist || die

	for i in *-${PV}.jar; do
		java-pkg_newjar $i ${i/-${PV}/}
		rm $i || die
	done

	java-pkg_dojar *.jar
	for i in *.jar; do
		java-pkg_dolauncher ${i/.jar/} --jar $i;
	done

	use source && java-pkg_dosrc "${S}"/src/java/*
	use doc && java-pkg_dojavadoc "${S}"/javadoc
}

src_test() {
	java-pkg-2_src_test
}
