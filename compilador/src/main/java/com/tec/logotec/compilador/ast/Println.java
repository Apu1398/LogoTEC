package com.tec.logotec.compilador.ast;

public class Println implements ASTNode {

	private ASTNode data;
	
	public Println(ASTNode data) {
		super();
		this.data = data;
	}

	@Override
	public Object execute() {
		System.out.println(data.execute());
		return null;
	}

}
