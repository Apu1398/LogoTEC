
package com.tec.logotec.compilador;
import java.io.IOException;

import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;

public class Main {

	private static final String EXTENSION = "logo";

	public static void main(String[] args) throws IOException {
		String program = args.length > 1 ? args[1] : "test/test." + EXTENSION;

		System.out.println("Interpreting file " + program);

		LogoTecLexer lexer = new LogoTecLexer(new ANTLRFileStream(program));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		LogoTecParser parser = new LogoTecParser(tokens);

		LogoTecParser.ProgramContext tree = parser.program();

		LogoTecCustomVisitor visitor = new LogoTecCustomVisitor();
		visitor.visit(tree);

		System.out.println("Interpretation finished");

	}

}
