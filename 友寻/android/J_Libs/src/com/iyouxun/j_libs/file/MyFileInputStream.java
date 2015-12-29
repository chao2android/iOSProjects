package com.iyouxun.j_libs.file;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class MyFileInputStream extends FileInputStream {
	protected Object sync;

	public MyFileInputStream(String path) throws FileNotFoundException {
		super(path);
	}

	public MyFileInputStream(FileDescriptor fd) {
		super(fd);
	}

	public MyFileInputStream(File file) throws FileNotFoundException {
		super(file);
	}

	@Override
	public int read() throws IOException {
		// synchronized (sync)
		{
			return super.read();
		}
	}

	@Override
	public int read(byte[] buffer, int byteOffset, int byteCount) throws IOException {
		// synchronized (sync)
		{
			return super.read(buffer, byteOffset, byteCount);
		}
	}

	@Override
	public int read(byte[] buffer) throws IOException {
		// synchronized (sync)
		{
			return super.read(buffer);
		}
	}

}
