FROM microsoft/dotnet:2.2-sdk
RUN echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib\r\ndeb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib\r\ndeb http://mirrors.aliyun.com/debian-security stretch/updates main\r\ndeb-src http://mirrors.aliyun.com/debian-security stretch/updates main\r\ndeb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\r\ndeb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\r\ndeb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib\r\ndeb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" > etc/apt/sources.list && apt update  -y


# Install perfcollect.
RUN curl -OL https://aka.ms/perfcollect && chmod +x perfcollect
RUN apt-get -y install babeltrace dh-python libc-dev-bin libc6-dev libkmod2 liblttng-ctl0 liblttng-ust-python-agent0 libmpdec2 libpython3-stdlib libpython3.5-minimal libpython3.5-stdlib liburcu-dev linux-libc-dev manpages manpages-dev python3 python3-minimal python3.5 python3.5-minimal uuid-dev zip linux-tools binutils

# Set tracing environment variables.
ENV COMPlus_PerfMapEnabled 1
ENV COMPlus_EnableEventLog 1

# Create, restore and build a new HelloWorld application.
RUN mkdir helloWorld && cd helloWorld && dotnet new console && \
	echo "using System;\n\nnamespace ConsoleApplication\n{\n\tpublic class Program\n\t{\n\t\tpublic static void Main(string[] args)\n\t\t{\n\t\t\tConsole.WriteLine(\"This application will allocate new objects in a loop forever.\");\n\t\t\twhile(true){ object o = new object(); }\n\t\t}\n\t}\n}" > Program.cs && \
	dotnet restore && dotnet build -c Release

# Run the app.
CMD cd /helloWorld && dotnet run -c Release