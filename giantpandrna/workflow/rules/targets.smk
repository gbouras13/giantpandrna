"""
All target output files are declared here
"""

if Kit == "DCS109":
    pychopperFile = os.path.join(FLAGS, "qc_dcs109.txt")
else:
    pychopperFile = os.path.join(FLAGS, "qc_pcs109.txt")

if Kit == "DCS109":
    pychopperNanoreceptor = os.path.join(FLAGS, "pychopperNanoreceptor.txt")
else:
    pychopperNanoreceptor = []


TargetFiles = [
    pychopperFile,
 os.path.join(FLAGS, "align.txt"),
 os.path.join(FLAGS, "align_raw.txt"),
 os.path.join(BAMBU,"se.rds"),
 os.path.join(ALIGN_RAW,"se_raw.rds"),
 #pychopperNanoreceptor,
 #os.path.join(FLAGS, "rawNanoreceptor.txt")
]