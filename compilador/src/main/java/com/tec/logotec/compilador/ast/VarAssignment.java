package com.tec.logotec.compilador.ast;

public class VarAssignment implements ASTNode {

	private String name;
	private ASTNode expression;
	
	
	
	public VarAssignment(String name, ASTNode expression) {
		super();
		this.name = name;
		this.expression = expression;
	}



	@Override
	public Object execute(Context symbolTable) {
		if(symbolTable.get(name).getClass().equals(expression.execute(symbolTable).getClass())) {
			symbolTable.put(name, expression.execute(symbolTable));
		}
		else {
			System.out.println("ERROR");
		}
		
		return null;
	}

}
