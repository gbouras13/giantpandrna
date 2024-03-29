"""
Database and output locations for the pipeline
"""

### reference directory
ReferenceDir = config["referenceDir"]


### OUTPUT DIRs
FLAGS = os.path.join(OUTPUT, 'FLAGS')
PROCESSING = os.path.join(OUTPUT, 'PROCESSING')
RESULTS = os.path.join(OUTPUT, 'RESULTS')



### qc.smk
PORECHOP = os.path.join(PROCESSING, 'PORECHOP')
NANOPLOT = os.path.join(PROCESSING, 'NANOPLOT')
PYCHOPPER = os.path.join(PROCESSING, 'PYCHOPPER')
PYCHOPPER_RESCUE = os.path.join(PROCESSING, 'PYCHOPPER_RESCUE')
FINAL_PYCHOPPER_DCS109 =  os.path.join(OUTPUT, 'FINAL_PYCHOPPER_DCS109')
FINAL_PYCHOPPER_PCS109_PCS111 =  os.path.join(OUTPUT, 'FINAL_PYCHOPPER_PCS109_PCS111')

#align.smk 
ALIGN = os.path.join(PROCESSING, 'ALIGN')
BAM_STATS = os.path.join(OUTPUT, 'BAM_STATS')


#quantify 
BAMBU = os.path.join(OUTPUT, 'BAMBU')

# nanareceptor
NANORECEPTOR_RAW = os.path.join(OUTPUT, 'NANORECEPTOR_RAW')



