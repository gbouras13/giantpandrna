"""
All target output files are declared here
"""

if Kit == "DCS109":
    pychopperFile = os.path.join(FLAGS, "qc_dcs109.txt")
else:
    pychopperFile = os.path.join(FLAGS, "qc_pcs109_pcs111.txt")


TargetFiles = [
 os.path.join(FLAGS, "nanoplot_aggr.txt"),
 pychopperFile,
 os.path.join(FLAGS, "align.txt"),
 os.path.join(BAMBU,"se.rds"),
 #os.path.join(FLAGS, "nanoreceptor.txt")
]