import pytest
import subprocess

modules = ["CONS", "DNA", "FIB", "FIBD", "GC", "GRPH", "HAMM", "IPRB",
           "LCSM", "LEXF", "MPRT", "MRNA", "ORF", "PERM", "PPER",
           "PROB", "PROT", "PRTM", "REVC", "REVP", "RNA", "SIGN",
           "SPLC", "SSEQ", "SUBS", "TRAN", "LGIS", "PMCH", "TREE",
           "LONG", "SSET", "LEXV", "INOD", "PDST", "KMER", "KMP",
           "REAR", "SORT", "RSTR", "LCSQ", "CAT", "MMCH", "CORR",
           "EDIT", "EVAL", "SPEC", "SCSP", "TRIE", "MOTZ", "ASPC",
           "NWCK", "SETO", "DBRU", "EDTA", "CONV", "INDC", "RNAS",
           "NKEW", "ITWV", "LREP", "CTBL", "FULL", "AFRQ", "CUNR",
           "QRT", "GLOB", "PCOV", "PRSM", "LOCA", "SIMS", "CTEA",
           "SEXL", "CSTR", "SGRA", "ROOT", "SUFF", "OAP", "PDPL",
           "GCON", "EBIN", "SPTD", "OSYM", "GAFF", "LAFF", "GASM",
           "ASMQ", "MULT", "MREP", "SMGB", "GREP", "CNTQ", "KSIM",
           "EUBT", "MGAP", "CHBP", "CSET"]

modules_need_blas = ["IEV", "LIA", "WFMD", "FOUN", "MEND", "ALPH"]


def compile_idfn(module):
    return "compile_" + module


def compile_blas_idfn(module):
    return "compile_" + module + "_blas"


@pytest.mark.parametrize("module", modules, ids=compile_idfn)
def test_basic_compilation(module):
    lowercase = module.lower()
    sourcecode = lowercase+'.chpl'
    executable = lowercase

    ret_val = subprocess.check_call(['chpl', '--fast', '--local',
                                     '-o', executable, sourcecode],
                                    cwd='./problems/'+module)
    assert ret_val == 0


@pytest.mark.parametrize("module", modules_need_blas, ids=compile_blas_idfn)
def test_basic_compilation_blas(module):
    lowercase = module.lower()
    sourcecode = lowercase+'.chpl'
    executable = lowercase

    BLASLIB = '/usr/local/Cellar/openblas/0.2.20/lib/'
    BLASINC = '/usr/local/Cellar/openblas/0.2.20/include/'
    ret_val = subprocess.check_call(['chpl', '-o', executable, sourcecode,
                                     '-L'+BLASLIB, '-llapack', '-lblas',
                                     '-I'+BLASINC],
                                    cwd='./problems/'+module)
    assert ret_val == 0
