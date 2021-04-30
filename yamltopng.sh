#/bin/bash
#TODO - validate command line args
yaml_inputfile=$1
intermediate_gliffy_file=${TMPDIR}$$.gliffy
png_outputfile=$2
docker run -v ${yaml_inputfile}:/input/org.yml  yamltogliffy > ${intermediate_gliffy_file}
echo ruby drivegliffy.rb ${intermediate_gliffy_file} ${png_outputfile}
ruby drivegliffy.rb ${intermediate_gliffy_file} ${png_outputfile}
rm ${intermediate_gliffy_file}
